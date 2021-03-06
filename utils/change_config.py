#!/usr/bin/env python
import os
import sys
sys.path.append('.')
from utils.read_config import ReadConfig


class ChangeConfig():
    def __init__(self, app_name, theme, ld):
        conf = ReadConfig(app_name).get()
        self.path = self.__add_home_path(conf['path'])
        self.keyword = conf['key_word']
        self.value = conf[theme][ld]

    def change(self):
        """read config from file
        change keyword valude
        write config to file
        """
        lines = []
        with open(self.path, mode='r') as conf_file:
            lines = conf_file.readlines()
            for index in range(len(lines)):
                if(lines[index].find(self.keyword) != -1):
                    # bug: splited string include \n at end of line
                    # use rstrip remove trailing whitespace to fix it
                    old = lines[index].split('=')[1].rstrip()
                    lines[index] = lines[index].replace(old, self.value)
                    break

        with open(self.path, mode='w') as conf_file:
            conf_file.writelines(lines)

    def __add_home_path(self, path):
        return os.path.expanduser('~') + '/' + path

if __name__ == '__main__':
    app_name = sys.argv[1]
    theme = sys.argv[2]
    ld = sys.argv[3]
    cc = ChangeConfig(app_name, theme, ld)
    cc.change()