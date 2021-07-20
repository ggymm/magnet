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

        model_list = []
        for rule in rule_list:
            model_list.append({
                "key": rule["id"],
                "value": rule["name"],
            })
            fp = codecs.open("rule/" + rule["id"] + ".json", "w", "utf-8")
            fp.write(json.dumps({rule["id"]: rule}, ensure_ascii=False, sort_keys=True, indent=4, separators=(", ", ": ")))

        model_str = ""
        for model in model_list:
            model_str += """
    ListElement {
        key: "%s"
        value: "%s"
    }""" % (model["key"], model["value"])

        print(model_str)
