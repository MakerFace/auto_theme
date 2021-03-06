#!/usr/bin/env python3

import sys
import change_config

def change_crontab():
    with open('/tmp/crontab.bak') as crontab:
        lines = crontab.readlines()
        for i in range(len(lines)):
            if lines[i].find("light") != -1:
                light = lines[i].split(' ')
                lines[i] = lines[i].replace(light[0], light_time[0], 1)
                lines[i] = lines[i].replace(light[1], light_time[1], 1)                
            elif lines[i].find("night") != -1:
                light = lines[i].split(' ')
                lines[i] = lines[i].replace(light[0], night_time[0], 1)
                lines[i] = lines[i].replace(light[1], night_time[1], 1)
    with open('/tmp/crontab.bak', 'w') as crontab:
        crontab.writelines(lines)

if __name__ == '__main__':
    light_time = [sys.argv[1], sys.argv[2]]
    night_time = [sys.argv[3], sys.argv[4]]
    change_crontab()