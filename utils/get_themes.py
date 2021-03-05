#!/usr/bin/env python3

import sys
sys.path.append('.')
from utils import read_config

def get_themes():
    res = read_config.open_yaml()['themes']
    str = ""
    for r in res:
        str += r + ','
    print(str)

if __name__ == '__main__':
    get_themes()
