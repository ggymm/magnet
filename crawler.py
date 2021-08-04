import json
import re
import sys
from urllib import parse

from html5lib import HTMLParser, treebuilders
from loguru import logger
from lxml import etree
from requests import get

from user_agent import random_ua

magnet_head = 'magnet:?xt=urn:btih:'


def run_crawler(key: str, search_terms: str, page: int, sort: str, proxies):
    rule_name = f'rule/{key}.json'
    logger.info('搜索任务开始执行')
    logger.info(f'文件名称: {rule_name}, 搜索词: {search_terms}, 页数: {page}, 排序规则: {sort}')

    try:
        with open(rule_name, encoding = 'utf-8') as rule_json:
            rule = json.load(rule_json)

            # 排序条件
            # TODO: 各个网站规则不一，暂不实现
            if len(sort) == 0:
                path = rule['path']['default'].format(k = search_terms, p = page)
            else:
                path = ''
            page_url = rule['url'] + path
            logger.info(f'搜索网址: {page_url}')

            # 发送请求获取数据
            headers = {
                'referer':    parse.quote(rule['referer']),
                'user-agent': random_ua()
            }
            content = get(page_url, timeout = 10, headers = headers, proxies = proxies)
            parser = HTMLParser(treebuilders.getTreeBuilder('lxml'), namespaceHTMLElements = False)
            document = parser.parse(content.text)

            # 获取页数
            page_sel = rule['parse']['page']
            page_num = ''
            for sel in page_sel:
                if sel['type'] is None:
                    page_num = '0'
                    break
                elif sel['type'] == 'xpath':
                    page_elem = document.xpath(sel['xpath'])
                    if len(page_elem) == 0:
                        page_num = '0'
                    else:
                        page_num = page_elem[0]
                elif sel['type'] == 'regex':
                    page_num = re.findall(sel['regex'], page_num)
                    if len(page_num) == 0:
                        page_num = '0'
                    else:
                        page_num = page_num[0]
            page_num = int(page_num)

            # 获取数据列表（字符串格式）
            data_result = []
            item_list = []
            if rule['parse']['item']["type"] == "xpath":
                elem_list = document.xpath(rule['parse']['item']['xpath'])
                for elem in elem_list:
                    item_list.append(etree.tostring(elem, encoding = str))
            elif rule['parse']['item']["type"] == "url":
                item_urls = document.xpath(rule['parse']['item']['xpath'])
                start = 0
                end = len(item_urls)
                if page_num == 0:
                    page_num = int(len(item_urls) / 10)
                    if page <= page_num:
                        start = (page - 1) * 10
                        end = start + 10
                for index in range(start, end):
                    url = rule['url'] + item_urls[index]
                    item_content = get(url, timeout = 10, headers = headers, proxies = proxies)
                    item_list.append(item_content.text)
            logger.info(f'结果列表: {item_list}')

            # 解析数据列表
            for index in range(rule['parse']['item']['startIndex'], len(item_list)):
                # 按照规则解析数据
                item_data = {
                    'magnet': 'magnet',
                    'name':   'name',
                    'hot':    'hot',
                    'size':   'size',
                    'time':   'time',
                }
                for key in item_data:
                    value = ''

                    # 遍历规则处理数据
                    for sel in rule['parse'][item_data[key]]:
                        # xpath匹配规则
                        if sel['type'] == 'xpath':
                            value = etree.HTML(item_list[index]).xpath(sel['xpath'])
                            # xpath匹配结果都是列表
                            if len(value) == 0:
                                value = ''
                            else:
                                value = value[0]

                        # xpath列表匹配规则
                        if sel['type'] == 'xpathList':
                            values = etree.HTML(item_list[index]).xpath(sel['xpath'])
                            # xpath匹配结果是列表
                            if len(values) == 0:
                                value = ''
                            else:
                                value = ''
                                for text in values:
                                    value += text

                        # 字符串截取规则
                        elif sel['type'] == 'subIndex':
                            # 起始和结束不设置时
                            # 需要为null值
                            start = 0 if sel['start'] is None else sel['start']
                            end = len(value) if sel['end'] is None else sel['end']
                            value = value[start:end]

                        # 正则表达式匹配规则
                        elif sel['type'] == 'regex':
                            value = re.findall(sel['regex'], value)
                            # 正则匹配结果是列表
                            if len(value) == 0:
                                value = ''
                            else:
                                value = value[0]

                        # 没有规则，取默认值
                        elif sel['type'] is None:
                            value = sel['default']
                            break

                    # fix: 某些链接提取后不完整
                    if key == 'magnet' and magnet_head not in value:
                        value = magnet_head + value

                    # fix: 移除一些错误字符
                    if key == 'name':
                        # &nbsp
                        value = value.replace(u'\xa0', u'')

                    # 保存解析后数据
                    item_data[key] = value

                data_result.append(item_data)
    except Exception as e:
        # 监听到异常
        logger.error(f'出现异常, {e.with_traceback(sys.exc_info()[2])}')
        return None
    else:
        # 没有异常返回正确数据
        logger.success(f'解析后结果列表: {data_result}')
        return {
            "page": page_num,
            "list": data_result
        }
    finally:
        # 有无异常都会最终执行的操作
        logger.info('搜索任务执行完毕')
