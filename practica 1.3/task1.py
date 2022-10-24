from time import sleep
from unittest import expectedFailure
import requests
from bs4 import BeautifulSoup
import json
import tqdm 

exp_dict = {
    'Нет опыта': 'noExperience',
    'От 1 года до 3 лет':'between1And3',
    'От 3 до 6 лет': 'between3And6',
    'Более 6 лет': 'moreThan6'}
                
headers = {'accept': '*/*',
            'User-Agent': "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.5112.124 YaBrowser/22.9.2.1495 Yowser/2.5 Safari/537.36"}

date_parse = {
    "data": []
}

def get_page():
    pages = soup.find('div', {'class':'pager'}).find_all(attrs={'data-qa':'pager-page'})[-1].text
    return int(pages)

for exp in range(len(exp_dict)):    
    base_url = f'https://stavropol.hh.ru/search/vacancy?experience={list(exp_dict.values())[exp]}&search_field=name&search_field=company_name&search_field=description&text=python+разработчик&items_on_page=20'
    response = requests.get(base_url, headers = headers)
    soup = BeautifulSoup(response.text, "lxml")

    for item in range(0, get_page()):
        url_page = base_url + '&page={item}'
        resp = requests.get(url_page, headers = headers)
        soup = BeautifulSoup(resp.text, "lxml")

        for element in tqdm.tqdm(soup.find_all('div', {'class':"serp-item"})):
            title = element.find('a', {'class':'serp-item__title'}).text
            work_exp = list(exp_dict.keys())[exp]
            region = element.find(attrs={'data-qa':'vacancy-serp__vacancy-address'}).text 
            try:
                salary = element.find(attrs={"data-qa":"vacancy-serp__vacancy-compensation"}).text
            except:
                salary = None
            date_parse['data'].append({'title': title, 'work experience': work_exp, 'salary': salary, "region": region})
            
            with open('data.json', "w", encoding ='utf8') as file:
                json.dump(date_parse, file, ensure_ascii=False)

        sleep(10)

