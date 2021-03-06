#!/usr/bin/env python3

import sys
sys.path.append('.')
from utils.read_config import ReadConfig

def get_themes():
    res = ReadConfig("themes")
    res = res.list_to_shell_array(res.get())
    print(res)

if __name__ == '__main__':
    get_themes()
