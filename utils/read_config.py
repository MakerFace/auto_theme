#!/usr/bin/env python3

# TODO read yaml
import yaml

yml = 'config/config.yml'

def open_yaml():
    with open(yml) as file:
        res = yaml.safe_load(file)
        return res

def get_themes():
    return open_yaml()['themes']

def get_vscode():
    return open_yaml()['vscode']

def get_location():
    return open_yaml()['location']

def get_themes():
    return open_yaml()['themes']

def get_gnome():
    return open_yaml()['gnome']

def get_all():
    return open_yaml()