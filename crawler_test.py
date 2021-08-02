from requests import get

from crawler import run_crawler
from user_agent import random_ua

key = 'cursor'
search_terms = '龙珠'
page = 1
sort = ''

proxies = {'http': 'http://127.0.0.1:9910', 'https': 'http://127.0.0.1:9910', }


def test_request():
    headers = {
        'user-agent': random_ua()
    }

    # 发送请求获取数据
    # https://bot.sannysoft.com/
    # https://httpbin.org/headers
    content = get("https://bot.sannysoft.com/", timeout = 10, headers = headers)
    print(content.text)


def test_crawler():
    data = run_crawler(key, search_terms, page, sort)
    print(len(data))
    for d in data:
        print(d)


if __name__ == '__main__':
    test_request()
