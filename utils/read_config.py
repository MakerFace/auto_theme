#!/usr/bin/env python3

# TODO read yaml
import yaml


class ReadConfig():
    def __init__(self, app_name=None, theme=None, ld=None):
        self.yml = 'config/config.yml'
        self.__config = None
        self.__open_yaml()
        self.app_name = app_name
        self.theme = theme
        self.ld = ld

    def get(self):
        res = self.__config
        if (self.app_name != None):
            res = res[self.app_name]
            if (self.theme != None):
                res = res[self.theme]
                if(self.ld != None):
                    res = res[self.ld]
        return res

    def __open_yaml(self):
        with open(self.yml) as file:
            self.__config = yaml.safe_load(file)

    def list_to_shell_array(self, src=None):
        if (src==None):
            src = self.__config
        des = ""
        for r in src:
            des += r + ','
        return des

if __name__ == '__main__':
    import sys
    app_name = sys.argv[1]
    theme = sys.argv[2]
    ld = sys.argv[3]
    gnome = ReadConfig(app_name=app_name, theme=theme, ld=ld)
    print(gnome.get())
