import argparse
import datetime
import logging
import multiprocessing as mp
import re
import sys
from ua_parser import user_agent_parser
import json

logging.basicConfig(
    filename='logs/process.log',
    level=logging.DEBUG,
    format='%(asctime)s [%(levelname)s] %(name)s:%(message)s'
)


def check_input_params(argv: argparse.ArgumentParser) -> argparse.Namespace:
    argv.add_argument(
        "-i",
        "--input",
        help="Input log file path",
        required=True,
        metavar="FILE",
        type=argparse.FileType('r', encoding='UTF-8')
    )
    argv.add_argument(
        "-o",
        "--output",
        help="Output result file path",
        required='--database' in sys.argv,
        type=argparse.FileType('w', encoding='UTF-8')
    )
    argv.add_argument(
        "-db",
        "--database",
        help="Database connection",
        required='--output' in sys.argv
    )

    return argv.parse_args()


def check_db_connection(db: str) -> bool:
    print(f"DB connection string: {db}")
    return True


def get_chunks(log_file: str) -> list:
    # If you have N processors,
    # then we need memory to hold 2 * (N - 1) chunks (one processor
    # is reserved for the main process).
    # The size of a chunk is CHUNK_SIZE * average-line-length.
    # If the average line length were 100, then a chunk would require
    # approximately 1_000_000 bytes of memory.
    # So if you had, for example, a 16MB machine with 8 processors,
    # you would have more
    # than enough memory for this CHUNK_SIZE.
    CHUNK_SIZE = 1_000

    with open(log_file, 'r', encoding='utf-8') as f:
        chunk = []
        while True:
            line = f.readline()
            if line == '':
                break
            chunk.append(line)
            if len(chunk) == CHUNK_SIZE:
                yield chunk
                chunk = []

        if chunk:
            yield chunk


def transform_user(data: str) -> str:
    if data == "-":
        return ""
    return data


def transform_dt(data: str) -> str:
    if not data:
        return data
    dt = datetime.datetime.strptime(data, '%d/%b/%Y:%H:%M:%S %z').strftime('%Y-%m-%d %H:%M:%S%z')
    return dt


def get_user_key(ip: str, user: str) -> str:
    user_key = " ".join((ip, user))
    return user_key.strip()


def check_patterns(text: str) -> tuple[str, int]:
    bad_text_count = 0
    bad_text = False
    _question_pattern = re.compile(r" \?+")
    _hex_pattern = re.compile(r"\\x[0-9a-fA-F][0-9a-fA-F]")
    if _question_pattern.search(text):
        text = _question_pattern.sub("", text)
        # TODO Uncomment, if you need to see mismatches
        # logging.error(f"Question pattern match error, name: {text}")
        bad_text = True

    if _hex_pattern.search(text):
        text = _hex_pattern.sub("", text)
        # TODO Uncomment, if you need to see mismatches
        # logging.error(f"Hex pattern match error, device: {text}")
        bad_text = True

    if bad_text:
        bad_text_count += 1

    return text.strip(), bad_text_count


def get_device(device):
    device_family = device['family'] if device['family'] is not None else ""
    device_brand = device['brand'] if device['brand'] is not None else ""
    device_model = device['model'] if device['model'] is not None else ""

    device = f"{device_family} {device_brand} {device_model}"
    _device, bad_device_count = check_patterns(device)

    return _device, bad_device_count


def get_browser(browser):
    _browser, bad_browser_count = check_patterns(browser)
    return _browser, bad_browser_count


def get_os(os):
    os_family = os['family'] if os['family'] is not None else ""
    os_version = os['major'] if os['major'] is not None else ""
    _os = f"{os_family} {os_version}"
    return _os.strip()


def log_handler(chunk):
    chunk_processed = dict(
        error_count=0,
        log_count=0,
        bot_count=0,
        user_keys=[],
        bad_device_name_count=0,
        bad_browser_name_count=0,
        devices_json={}
    )
    for idx in range(len(chunk)):
        # TODO magic!
        regex_main = r"(?P<ip>.+?) (?P<info>.+?) (?P<user>.+?) \[(?P<dt>.+?)\] \"(?P<method>\w+) (?P<path>.+?) (" \
                     r"?P<protocol>.+?)\" (?P<status>\d+) (?P<size>\d+) \"(?P<reference>.+?)\" \"(?P<ua>.+?)\" \"(" \
                     r"?P<addition>.+?)\""
        matches = re.finditer(regex_main, chunk[idx])
        for matchNum, match in enumerate(matches, start=1):
            ip = match.group("ip")
            info = match.group("info") != "-"
            user = transform_user(match.group("user"))
            dt = transform_dt(match.group("dt"))
            method = match.group("method")
            path = match.group("path")
            protocol = match.group("protocol")
            status = int(match.group("status"))
            size = int(match.group("size"))
            reference = match.group("reference")
            ua = match.group("ua")
            addition = match.group("addition")

            # Get user key and define unique users
            user_key = get_user_key(
                ip=ip,
                user=user
            )
            if user_key not in chunk_processed['user_keys']:
                chunk_processed['user_keys'].append(user_key)

            ua_parsed = user_agent_parser.Parse(ua)
            # TODO This parser gives you following JSON (choose whatever you need in related functions).
            # TODO to see all use print(ua_parsed)
            # Example:
            """
            {
              "string":"Mozilla/5.0 (Linux; Android 4.4.4; SM-A500H Build/KTU84P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.81 Mobile Safari/537.36",
              "user_agent":{
                "family":"Chrome Mobile",
                "major":"51",
                "minor":"0",
                "patch":"2704"
              },
              "os":{
                "family":"Android",
                "major":"4",
                "minor":"4",
                "patch":"4",
                "patch_minor":"None"
              },
              "device":{
                "family":"Samsung SM-A500H",
                "brand":"Samsung",
                "model":"SM-A500H"
              }
            }
            """

            # Count log
            chunk_processed['log_count'] += 1

            # Count spiders
            if ua_parsed['device']['family'] == 'Spider':
                chunk_processed['bot_count'] += 1

            # Get device
            device, bad_device_count = get_device(ua_parsed['device'])
            if device == "Other":
                device = get_os(ua_parsed['os'])
            chunk_processed['bad_device_name_count'] += bad_device_count

            # Get browser
            browser, bad_browser_count = get_browser(ua_parsed['string'])
            chunk_processed['bad_browser_name_count'] += bad_device_count

            # Status info
            status_str = str(status)
            # TODO better check
            if not user_key or not status or not status_str or not device or not browser:
                chunk_processed['error_count'] += 1

            # Get Device JSON
            if device not in chunk_processed['devices_json']:
                chunk_processed['devices_json'][device] = dict(
                    use_count=1,
                    users=[user_key],
                    browsers={browser: [user_key]},
                    not_200_answers=1 if status != 200 else 0,
                    request_answers={status_str: 1} if status != 200 else {}
                )
            else:
                chunk_processed['devices_json'][device]['use_count'] += 1
                chunk_processed['devices_json'][device]['not_200_answers'] += 1 if status != 200 else 0
                if user_key not in chunk_processed['devices_json'][device]['users']:
                    chunk_processed['devices_json'][device]['users'].append(user_key)

                if browser not in chunk_processed['devices_json'][device]['browsers'].keys():
                    chunk_processed['devices_json'][device]['browsers'][browser] = [user_key]
                else:
                    if user_key not in chunk_processed['devices_json'][device]['browsers'][browser]:
                        chunk_processed['devices_json'][device]['browsers'][browser].append(user_key)

                if status != 200:
                    if status_str not in chunk_processed['devices_json'][device]['request_answers'].keys():
                        chunk_processed['devices_json'][device]['request_answers'][status_str] = 1
                    else:
                        chunk_processed['devices_json'][device]['request_answers'][status_str] += 1

    return chunk_processed


if __name__ == '__main__':
    # 1. Проверка параметров входа
    argv_parser = argparse.ArgumentParser(description="Log Analysis (Input parameters parser)")
    argv_params = check_input_params(argv_parser)

    # 2. Check what option is chosen and check connection to DB (if option is DB)
    log_file_path = argv_params.input.name
    if argv_params.database:
        result_file_path = None
        db_string = argv_params.database
        check_db_connection(db_string)
        logging.info(f"Save results to DB: {db_string}")
    else:
        result_file_path = argv_params.output.name
        db_string = None
        logging.info(f"Save results to FILE: {result_file_path}")

    logging.info(f"Process STARTED")

    # 3. Обработка log файла и запись в DB / файл
    if db_string:
        # TODO connection and save
        logging.error(f"Database connector in not implemented")
    else:
        with mp.Pool(mp.cpu_count() - 1) as pool, open(argv_params.output.name, 'w', encoding='utf-8') as nf:
            chunk_user_keys = []
            chunk_devices = {}
            chunk_calc = dict(
                log_count=0,
                error_count=0,
                bot_count=0,
                user_count=0,
                bad_device_name_count=0,
                bad_browser_name_count=0,
                device_count=0,
                devices={}
            )

            for chunk in pool.imap_unordered(log_handler, get_chunks(log_file=argv_params.input.name)):
                chunk_calc['error_count'] += chunk['error_count']
                chunk_calc['log_count'] += chunk['log_count']
                chunk_calc['bot_count'] += chunk['bot_count']
                chunk_calc['bad_device_name_count'] += chunk['bad_device_name_count']
                chunk_calc['bad_browser_name_count'] += chunk['bad_browser_name_count']

                # Merge chunk User Keys
                chunk_user_keys += list(set(chunk['user_keys']) - set(chunk_user_keys))

                # Merge chunk devices JSONs
                for device_key in chunk['devices_json'].keys():
                    if device_key not in chunk_devices:
                        chunk_devices[device_key] = dict(
                            use_count=chunk['devices_json'][device_key]['use_count'],
                            users=chunk['devices_json'][device_key]['users'],
                            browsers=chunk['devices_json'][device_key]['browsers'],
                            not_200_answers=chunk['devices_json'][device_key]['not_200_answers'],
                            request_answers=chunk['devices_json'][device_key]['request_answers']
                        )
                    else:
                        chunk_devices[device_key]['use_count'] += chunk['devices_json'][device_key]['use_count']
                        chunk_devices[device_key]['users'] += \
                            list(set(chunk['devices_json'][device_key]['users']) - set(chunk_devices[device_key]['users']))
                        xb = chunk_devices[device_key]['browsers']
                        yb = chunk['devices_json'][device_key]['browsers']
                        chunk_devices[device_key]['browsers'] = \
                            {i: xb.get(i, []) + list(set(yb.get(i, [])) - set(xb.get(i, []))) for i in
                             set(xb) | set(yb)}
                        chunk_devices[device_key]['not_200_answers'] += \
                            chunk['devices_json'][device_key]['not_200_answers']
                        xra = chunk_devices[device_key]['request_answers']
                        yra = chunk['devices_json'][device_key]['request_answers']
                        chunk_devices[device_key]['request_answers'] = \
                            {j: xra.get(j, 0) + yra.get(j, 0) for j in set(xra) | set(yra)}

            devices_json_result = {}
            for chunk_device_key in chunk_devices.keys():
                browsers_json_result = {}
                for browser_key in chunk_devices[chunk_device_key]["browsers"].keys():
                    browsers_json_result[browser_key] = len(chunk_devices[chunk_device_key]["browsers"][browser_key])

                browsers_sorted = sorted(browsers_json_result.items(), key=lambda x: x[1])
                devices_json_result[chunk_device_key] = dict(
                    use_count=chunk_devices[chunk_device_key]["use_count"],
                    use_share=chunk_devices[chunk_device_key]["use_count"] / chunk_calc['log_count'] if chunk_calc['log_count'] != 0 else 0,
                    user_count=len(chunk_devices[chunk_device_key]["users"]),
                    user_share=len(chunk_devices[chunk_device_key]["users"]) / len(chunk_user_keys) if len(chunk_user_keys) != 0 else 0,
                    not_200_answers=chunk_devices[chunk_device_key]["not_200_answers"],
                    request_answers=chunk_devices[chunk_device_key]["request_answers"],
                    browsers=dict(browsers_sorted)
                )

            result = dict(
                log_count=chunk_calc['log_count'],
                error_count=chunk_calc['error_count'],
                bot_count=chunk_calc['bot_count'],
                user_count=len(chunk_user_keys),
                bad_device_name_count=chunk_calc['bad_device_name_count'],
                bad_browser_name_count=chunk_calc['bad_browser_name_count'],
                device_count=len(devices_json_result.keys()),
                devices=devices_json_result
            )

            nf.write(json.dumps(result, indent=4))

    # 4. Уведомление о результате
    logging.info("Process FINISHED")
