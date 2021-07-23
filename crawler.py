import json
from urllib import parse

from lxml import etree
from requests import get

from user_agent import random_ua

magnet_head = "magnet:?xt=urn:btih:"


def run_crawler(key, search_terms, page, sort):
    rule_name = f"rule/{key}.json"

    try:
        with open(rule_name, encoding="utf-8") as f:
            conf = json.load(f)

            params = ""
            if len(sort) == 0:
                params = conf["params"]["default"].format(k=search_terms, p=page)

            url = conf["url"] + params

            headers = {
                "referer":    parse.quote(url),
                "user-agent": random_ua()
            }

            # 发送请求获取数据
            content = get(url, headers=headers)
            doc = etree.HTML(content.text)

            # 解析数据列表
            item_list = []
            elem_list = doc.xpath(conf["parse"]["item"]["xpath"])
            for elem in elem_list:
                item_list.append(etree.tostring(elem, encoding=str))

            data_result = []
            for item in item_list:
                item_data = {
                    "magnet": "magnet",
                    "name":   "name",
                    "hot":    "hot",
                    "size":   "size",
                    "time":   "time",
                }

                # 按照规则解析数据
                for key in item_data:
                    value = None
                    rules = conf["parse"][item_data[key]]

                    # 遍历规则处理数据
                    for rule in rules:
                        # xpath规则
                        if rule["type"] == "xpath":
                            value = etree.HTML(item).xpath(rule["xpath"])
                            # xpath匹配结果都是列表
                            if len(value) == 0:
                                value = value
                            else:
                                value = value[0]

                            # fix: 某些链接提取后不完整
                            if key == "magnet" and magnet_head not in value:
                                value = magnet_head + value

                        # 字符串截取规则
                        elif rule["type"] == "subIndex":
                            # 起始和结束不设置时
                            # 需要为null值
                            start = 0 if rule["start"] is None else rule["start"]
                            end = len(value) if rule["end"] is None else rule["end"]
                            value = value[start:end]

                        # 没有规则，取默认值
                        elif rule["type"] is None:
                            value = rule["default"]
                            break

                    # 保存解析后数据
                    item_data[key] = value

                data_result.append(item_data)
    except Exception as e:
        # 监听到异常
        print("出现异常", e)
        return None
    else:
        # 没有异常返回正确数据
        return data_result
    finally:
        # 有无异常都会最终执行的操作
        pass
