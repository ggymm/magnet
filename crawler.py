import json


def run_crawler(key, search_terms):
    rule_name = "rule/%s.json" % key
    with open(rule_name, encoding="utf-8") as f:
        conf = json.load(f)
        print(conf)

    return []
