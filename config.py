import json


class Config:
    def __init__(self):
        with open('config.json', 'r') as c:
            self._config = json.load(c)

    def save_config(self, config):
        print(config)
        self._config = config

        with open('config/proxy.json', 'r') as c:
            config = json.dumps(config, ensure_ascii = False, indent = 2, separators = (', ', ': '))
            c.write(config)

    def get_config(self):
        return self._config
