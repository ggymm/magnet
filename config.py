import json


class Config:
    def __init__(self):
        # 代理配置
        with open('config/proxy.json', 'r') as c:
            self._proxy_config = json.load(c)

        with open('config/search.json', 'r') as c:
            self._search_config = json.load(c)

    def save_proxy_config(self, server, port):
        self._proxy_config['server'] = server
        self._proxy_config['port'] = port

        with open('config/proxy.json', 'r') as c:
            config = json.dumps(self._proxy_config, ensure_ascii = False, indent = 2, separators = (', ', ': '))
            c.write(config)

    def save_search_config(self):
        pass
