#!/usr/bib/env python
import json
import sys
import os

vimrc_path = os.path.expanduser('~') + '/.vimrc'

def parseVimrc():
    lines = []
    with open(vimrc_path, mode='r') as vimrc:
        lines = vimrc.readlines()
        for index in range(len(lines)):
            if(lines[index].split('=')[0] == 'set background'):
                lines[index]='set background='+sys.argv[1]+'\n'
                break
        
    with open(vimrc_path, mode='w') as vimrc:
        vimrc.writelines(lines)

if __name__ == '__main__':
    parseVimrc()
