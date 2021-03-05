#!/bin/bash

function get_dbus() {
    compatiblePrograms=(nautilus kdeinit kded4 pulseaudio trackerd)

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

    QUERY_ENVIRON="$(tr '\0' '\n' </proc/${PID}/environ | grep "DBUS_SESSION_BUS_ADDRESS" | cut -d "=" -f 2-)"
    if [[ "${QUERY_ENVIRON}" != "" ]]; then
        export DBUS_SESSION_BUS_ADDRESS="${QUERY_ENVIRON}"
        echo "Connected to session:"
        echo "DBUS_SESSION_BUS_ADDRESS=${DBUS_SESSION_BUS_ADDRESS}"
    else
        echo "Could not find dbus session ID in user environment."
        return 1
    fi
}

workspace=$(
    cd "$(dirname "$0")"
    pwd
)
cd $workspace

function set_gnome() {
    theme=$(python gnome/lightdark.py $1 theme)
    cursor=$(python gnome/lightdark.py $1 cursor)
    terminal=$(python gnome/lightdark.py $1 terminal)
    shell=$(python gnome/lightdark.py $1 shell)

    echo 'gnome setting'
    gsettings set org.gnome.desktop.interface gtk-theme "$theme"
    echo "setting gtk-theme $theme"
    gsettings set org.gnome.desktop.interface cursor-theme "$cursor"
    echo "setting cursor-theme $cursor"
    gsettings set org.gnome.shell.extensions.user-theme name "$shell"
    echo "setting shell-theme $shell"
    gsettings set org.gnome.Terminal.ProfilesList default "$terminal"
    echo "setting terminal-theme $terminal"
    echo "----------------------"
}

function set_vscode() {
    # . ./vscode/lightdark.sh
    res=$(python vscode/lightdark.py "$1")
    echo "setting vscode theme" $res
    echo "----------------------"
}

function set_vim() {
    . ./vim/lightdark.sh
    echo "setting vim theme"
    echo "----------------------"
}

function update_time() {
    date_time=$(python ./utils/date_time.py)
    crontab -l >/tmp/crontab.bak
    python3 ./utils/change_crontab.py $date_time
    crontab /tmp/crontab.bak
    echo "update sunrise and sunset $date_time (minute:hour)"
    echo "-------finished-------"
}

get_dbus
set_gnome $1
set_vscode $1
# set_vim $1
update_time