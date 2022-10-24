import re
import string

def is_palindrome(s):
    pat = f"[\s{re.escape(string.punctuation)}]"
    s = re.sub(pat, "", s).lower()
    return s == s[::-1]

print(is_palindrome("taco cat"))
print(is_palindrome("rotator"))
print(is_palindrome("black cat"))

