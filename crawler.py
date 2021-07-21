import json

from pyquery import PyQuery
import requests

from user_agent import random_ua

magnet_prefix = "magnet:?xt=urn:btih:"


# 获取列表项的详情,不校验拼写错误(网站名都很奇怪)
# noinspection SpellCheckingInspection
class GetDetail:
    def __init__(self):
        pass

    def is_not_used(self):
        pass

    def btgg(self, item: PyQuery):
        self.is_not_used()

        name = item(".name").children("a").text()
        metas = list(item(".meta").items("span"))
        size = metas[0].text()[:-1]
        time = metas[2].text()[:-1]
        magnet = item(".mate").children("a").attr("href")

        return {"name": name, "hot": "999", "size": size, "time": time, "magnet": magnet}

    def btsow(self, item: PyQuery):
        self.btsow_shadow(item)

    def btsow_shadow(self, item: PyQuery):
        self.is_not_used()

        magnet = item("a").attr("href")
        if magnet is None:
            return None
        name = item("a").attr("title")
        size = item(".size").text()
        time = item(".date").text()
        magnet = magnet_prefix + magnet[-40:]

        return {"name": name, "hot": "999", "size": size, "time": time, "magnet": magnet}


def run_crawler(key, search_terms, page, sort):
    rule_name = f"rule/pro/{key}.json"
    with open(rule_name, encoding="utf-8") as f:
        conf = json.load(f)

        search_info = ""
        if len(sort) == 0:
            search_info = conf["paths"]["default"].format(k=search_terms, p=page)

        url = conf["url"] + search_info

        headers = {
            # "referer": url,
            "user-agent": random_ua()
        }

        # 发送请求获取数据
        content = requests.get(url, headers=headers)
        doc = PyQuery(content.text)

        # 解析数据列表
        detail_func = getattr(GetDetail(), key)
        data_list = doc(conf["selector"])
        data_result = []
        for item in data_list.items():
            item(".name").text()
            item_result = detail_func(item)
            if item_result is not None:
                data_result.append(item_result)

    return data_result
