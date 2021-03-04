#!/usr/bib/env python
import json
import sys
import os

setting_path = os.path.expanduser('~') + '/.config/Code/User/settings.json'


def parseJson():
    set_json = None
    with open(setting_path, mode='r') as json_file:
        set_json = json.load(json_file)
        set_json['workbench.colorTheme'] = sys.argv[1]

    with open(setting_path, mode='w') as json_file:
        json.dump(set_json, json_file)

if __name__ == '__main__':
    parseJson()
