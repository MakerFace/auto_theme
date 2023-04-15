#!/usr/bin/env python3
import sys
import os
sys.path.append('.')

from utils.read_config import ReadConfig

def get_terminator(app_name):
    res = ReadConfig(app_name)
    return res.get()

def set_profile():
    config = get_terminator(sys.argv[1])
    setting_path = os.path.expanduser('~') + '/' + config['path']
    theme = config[sys.argv[2]][sys.argv[3]]
    keyword = config['keyword']
    set_config = []
    is_layouts = False
    is_default = False
    with open(setting_path, mode='r') as config_file:
        for line in config_file:
            if 'layouts' in line:
                is_layouts = True
            elif 'default' in line:
                is_default = True

            if is_layouts and is_default and keyword in line:
                set_config.append('      profile = "{}"\n'.format(theme))
            else:
                set_config.append(line)
    with open(setting_path, mode='w') as config_file:
        config_file.writelines(set_config)

if __name__ == '__main__':
    set_profile()