#!/usr/bin/env python3
import json
import sys
import os

# setting_path = os.path.expanduser('~') + '/.config/Code/User/settings.json'
sys.path.append('.')

from utils.read_config import ReadConfig

def get_vscode(app_name):
    res = ReadConfig(app_name)
    # print(res)
    return res.get()

def parseJson():
    set_json = None
    config = get_vscode(sys.argv[1])
    setting_path = os.path.expanduser('~') + "/" + config['path']
    theme = config[sys.argv[2]][sys.argv[3]]
    key_word = config['key_word']
    with open(setting_path, mode='r') as json_file:
        set_json = json.load(json_file)
        set_json[key_word] = theme

    with open(setting_path, mode='w') as json_file:
        json.dump(set_json, json_file)

if __name__ == '__main__':
    parseJson()
