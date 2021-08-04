import json
from urllib import parse

from html5lib import HTMLParser, treebuilders
from lxml import etree
from requests import get

from crawler import run_crawler
from user_agent import random_ua

key = '9cili'
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
    data = run_crawler(key, search_terms, page, sort, proxies)
    print(len(data))
    for d in data:
        print(d)


def test_9cili():
    rule_name = f'rule/{key}.json'
    with open(rule_name, encoding = 'utf-8') as rule_json:
        rule = json.load(rule_json)
        page_url = rule['url'] + rule['path']['default'].format(k = search_terms, p = page)
        headers = {
            'referer':    parse.quote(rule['referer']),
            'user-agent': random_ua()
        }
        content = get(page_url, timeout = 10, headers = headers)

        parser = HTMLParser(treebuilders.getTreeBuilder('lxml'), namespaceHTMLElements = False)

        doc = parser.parse(content.text)
        print(etree.tostring(doc, encoding = str))

        elem_list = doc.xpath('//div[@class="search_list"]/dl')
        for elem in elem_list:
            print(etree.tostring(elem, encoding = str))


if __name__ == '__main__':
    # test_request()
    test_9cili()
