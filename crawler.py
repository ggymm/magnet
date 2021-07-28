import gc
import json
import re
from urllib import parse

from loguru import logger
from lxml import etree
from requests import get

from user_agent import random_ua

magnet_head = 'magnet:?xt=urn:btih:'


def run_crawler(key, search_terms, page, sort):
    rule_name = f'rule/{key}.json'
    logger.info('搜索任务开始执行')
    logger.info(f'文件名称: {rule_name}, 搜索词: {search_terms}, 页数: {page}, 排序规则: {sort}')

    try:
        with open(rule_name, encoding = 'utf-8') as rule_json:
            rule = json.load(rule_json)

            params = ''
            if len(sort) == 0:
                params = rule['params']['default'].format(k = search_terms, p = page)
            url = rule['url'] + params
            logger.info(f'搜索网址: {url}')

            headers = {
                'referer':    parse.quote(rule['referer']),
                'user-agent': random_ua()
            }

            # 发送请求获取数据
            content = get(url, timeout = 10, headers = headers)
            doc = etree.HTML(content.text)

            # 解析数据列表
            item_list = []
            item_rule = rule['parse']['item']
            elem_list = doc.xpath(item_rule['xpath'])
            for elem in elem_list:
                item_list.append(etree.tostring(elem, encoding = str))
            logger.info(f'结果列表: {item_list}')

            data_result = []
            start = item_rule['startIndex']
            for index in range(start, len(item_list)):
                item_data = {
                    'magnet': 'magnet',
                    'name':   'name',
                    'hot':    'hot',
                    'size':   'size',
                    'time':   'time',
                }

                # 按照规则解析数据
                for key in item_data:
                    value = None
                    selector = rule['parse'][item_data[key]]

                    # 遍历规则处理数据
                    for sel in selector:
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
                            # xpath匹配结果都是列表
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
                            # 匹配结果是列表
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
        logger.error(f'出现异常, {e}')
        return None
    else:
        # 没有异常返回正确数据
        logger.success(f'解析后结果列表: {data_result}')
        return data_result
    finally:
        # 有无异常都会最终执行的操作
        logger.info('搜索任务执行完毕')
        pass
