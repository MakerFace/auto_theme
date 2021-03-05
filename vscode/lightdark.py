#!/usr/bib/env python3
import json
import sys
import os

setting_path = os.path.expanduser('~') + '/.config/Code/User/settings.json'
sys.path.append('.')

from utils import read_config

def get_vscode():
    res = read_config.get_vscode()['theme'][sys.argv[1]]
    print(res)
    return res

def parseJson():
    set_json = None
    theme = get_vscode()
    with open(setting_path, mode='r') as json_file:
        set_json = json.load(json_file)
        set_json['workbench.colorTheme'] = theme

    with open(setting_path, mode='w') as json_file:
        json.dump(set_json, json_file)

if __name__ == '__main__':
    parseJson()
