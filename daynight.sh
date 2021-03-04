#!/bin/bash

compatiblePrograms=( nautilus kdeinit kded4 pulseaudio trackerd )

for index in ${compatiblePrograms[@]}; do
    PID=$(pidof -s ${index})
    if [[ "${PID}" != "" ]]; then
        break
    fi
done
if [[ "${PID}" == "" ]]; then
    echo "Could not detect active login session"
    return 1
fi

QUERY_ENVIRON="$(tr '\0' '\n' < /proc/${PID}/environ | grep "DBUS_SESSION_BUS_ADDRESS" | cut -d "=" -f 2-)"
if [[ "${QUERY_ENVIRON}" != "" ]]; then
    export DBUS_SESSION_BUS_ADDRESS="${QUERY_ENVIRON}"
    echo "Connected to session:"
    echo "DBUS_SESSION_BUS_ADDRESS=${DBUS_SESSION_BUS_ADDRESS}"
else
    echo "Could not find dbus session ID in user environment."
    return 1
fi

workspace=$(cd "$(dirname "$0")";pwd)
echo "now workspace is $workspace"

light_theme=Mojave-light
night_theme=Mojave-dark

# light_cursor=MacOS-3D-Cursor-Dark
light_cursor=Capitaine-cursors
# night_cursor=MacOS-3D-Cursor-Light
light_cursor=Capitaine-cursors-light

light_shell=Mojave-light
night_shell=Mojave-dark

light_terminal=2e064c23-220a-4ec6-9b1e-d8d0f51351de
night_terminal=a098cf48-224b-4aee-b4ce-a02700d0b7d8 # material

if [ $1 = 'light' ];then
    echo 'select light'
    theme=$light_theme
    cursor=$light_cursor
    shell=$light_shell
    terminal=$light_terminal
else
    echo 'select night'
    theme=$night_theme
    cursor=$night_cursor
    shell=$night_shell
    terminal=$night_terminal
fi

echo 'gnome setting'
gsettings set org.gnome.desktop.interface gtk-theme "$theme"
echo "setting gtk-theme $theme"
gsettings set org.gnome.desktop.interface cursor-theme "$cursor"
echo "setting cursor-theme $cursor"
gsettings set org.gnome.Terminal.ProfilesList default "$terminal"
echo "setting terminal-theme $terminal"

cd $workspace
. ./vscode/lightdark.sh
echo "setting vscode theme"

. ./vim/lightdark.sh
echo "setting vim theme"

echo 'finished'
#gsettings set org.gnome.desktop.interface 
# change next execute time
date_time=`python ./utils/date_time.py`
crontab -l > /tmp/crontab.bak
python ./utils/change_crontab.py $date_time
crontab /tmp/crontab.bak