import requests
import codecs
import json

# 规则文件地址
# https://magnetw.app/rule.json
if __name__ == "__main__":

    url = "https://magnetw.app/rule.json"
    rule_json = requests.get(url)
    open("rule.json", "wb").write(rule_json.content)

    with open("rule.json", encoding="utf-8") as f:
        rule_list = json.load(f)

        for rule in rule_list:
            result = {rule["id"]: rule}
            fp = codecs.open("rule/" + rule["id"] + ".json", "w", "utf-8")
            fp.write(json.dumps(result, ensure_ascii=False, sort_keys=True, indent=4, separators=(", ", ": ")))
