#!/usr/bin/env python
import sys
sys.path.append('.')

from utils import read_config

class gnome:
    def theme(self, ld):
        print(read_config.get_gnome()['theme'][ld])

    def cursor(self, ld):
        print(read_config.get_gnome()['cursor'][ld])

    def terminal(self, ld):
        print(read_config.get_gnome()['terminal'][ld])

if __name__ == '__main__':
    obj = gnome()
    f = getattr(obj, sys.argv[2])
    f(sys.argv[1])