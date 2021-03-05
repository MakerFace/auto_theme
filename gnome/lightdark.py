#!/usr/bin/env python3
import sys
sys.path.append('.')

from utils import read_config

class gnome:
    '''
    param @ld light or dark
    '''
    def theme(self, ld):
        print(read_config.get_gnome()['theme'][ld])

    def cursor(self, ld):
        print(read_config.get_gnome()['cursor'][ld])

    def terminal(self, ld):
        print(read_config.get_gnome()['terminal'][ld])

    def shell(self, ld):
        print(read_config.get_gnome()['shell'][ld])

if __name__ == '__main__':
    obj = gnome()
    f = getattr(obj, sys.argv[2])
    f(sys.argv[1])