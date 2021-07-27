import os

import requests
import codecs
import json


# 更新规则数据
def gen_rules():
    url = 'https://magnetw.app/rule.json'
    rule_json = requests.get(url)
    open('rule.json', 'wb').write(rule_json.content)

    with open('rule.json', encoding='utf-8') as f:
        rule_list = json.load(f)
        for rule in rule_list:
            fp = codecs.open('../rule/resource/' + rule['id'] + '.json', 'w', 'utf-8')
            fp.write(json.dumps(rule, ensure_ascii=False, sort_keys=False, indent=2, separators=(', ', ': ')))


# 生成UI结构
def gen_list_model():
    file_path = '../rule'
    file_list = os.listdir(file_path)

    model_str = ''
    for file in file_list:
        if os.path.isfile(file_path + '/' + file):
            with open(file_path + '/' + file, encoding='utf-8') as f:
                rule_obj = json.load(f)
                model_str += '''
        ListElement {
            key: '%s'
            value: '%s'
        }''' % (rule_obj['id'], rule_obj['name'])

    print(model_str)


# 规则文件地址
# https://magnetw.app/rule.json
if __name__ == '__main__':
    print('规则相关工具链')
    gen_list_model()
    # gen_rules()
