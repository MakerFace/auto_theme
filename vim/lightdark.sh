#!/bin/sh

light_theme="light"
night_theme="dark"

if [ 'light' == $1 ]; then
    theme=$light_theme
else
    theme=$night_theme
fi

python ./vim/lightdark.py "$theme"