#!/bin/bash

key_theme=workbench.colorTheme
# light_theme="Atom One Light"
light_theme="GitHub Light"
# night_theme="Atom One Dark"
night_theme="GitHub Dark"

if [ 'light' == $1 ]; then
    theme=$light_theme
else
    theme=$night_theme
fi

python ./vscode/lightnight.py "$theme"