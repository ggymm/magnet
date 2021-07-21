import json
import time

import requests

from user_agent import random_ua


def run_crawler(key, search_terms, page, sort):
    rule_name = "rule/pro/%s.json" % key
    with open(rule_name, encoding="utf-8") as f:
        conf = json.load(f)

        search_info = ""
        if len(sort) == 0:
            search_info = conf["paths"]["default"].replace("{k}", search_terms).replace("{p}", page)

        url = conf["url"] + search_info

        headers = {
            # "referer": url,
            "user-agent": random_ua()
        }

        content = requests.get(url, headers=headers)
        print(content.content)

    return [{"test": "test"}]
