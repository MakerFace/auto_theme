#!/usr/bin/env bash
cd $(cd "$(dirname "$0")";pwd)

source ./bash-yaml/script/yaml.sh

#TODO read yaml
config=$PWD/file.yml
parse_yaml $config

echo ${gnome_}
