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
        $(logout "Could not detect active login session")
        return 1
    fi

    QUERY_ENVIRON="$(tr '\0' '\n' </proc/${PID}/environ | grep "DBUS_SESSION_BUS_ADDRESS" | cut -d "=" -f 2-)"
    if [[ "${QUERY_ENVIRON}" != "" ]]; then
        export DBUS_SESSION_BUS_ADDRESS="${QUERY_ENVIRON}"
        $(logout "Connected to session:")
        $(logout "DBUS_SESSION_BUS_ADDRESS=${DBUS_SESSION_BUS_ADDRESS}")
    else
        $(logout "Could not find dbus session ID in user environment.")
        return 1
    fi
}

workspace=$(
    cd "$(dirname "$0")"
    pwd
)
cd $workspace

function logout() {
    echo $1 >>test.log
}

function gnome() {
    theme=$(python3 gnome/lightdark.py $1 theme)
    cursor=$(python3 gnome/lightdark.py $1 cursor)
    terminal=$(python3 gnome/lightdark.py $1 terminal)
    shell=$(python3 gnome/lightdark.py $1 shell)

    $(logout 'gnome setting')
    gsettings set org.gnome.desktop.interface gtk-theme "$theme"
    $(logout "setting gtk-theme $theme")
    gsettings set org.gnome.desktop.interface cursor-theme "$cursor"
    $(logout "setting cursor-theme $cursor")
    gsettings set org.gnome.shell.extensions.user-theme name "$shell"
    $(logout "setting shell-theme $shell")
    gsettings set org.gnome.Terminal.ProfilesList default "$terminal"
    $(logout "setting terminal-theme $terminal")
    $(logout "----------------------")
}

function vscode() {
    res=$(python3 vscode/lightdark.py "$1")
    $(logout "setting vscode theme $res")
    $(logout "----------------------")
}

function vim() {
    . vim/lightdark.sh
    $(logout "setting vim theme")
    $(logout "----------------------")
}

function spaceVim() {
    :
}

function update_time() {
    date_time=$(python3 utils/date_time.py)
    crontab -l >/tmp/crontab.bak
    python3 utils/change_crontab.py $date_time
    crontab /tmp/crontab.bak
    $(logout "update sunrise and sunset $date_time (minute:hour)")
}

function split_string() {
    old_ifs=$IFS
    IFS=,
    arr=$1
    echo ${arr[@]}
    IFS=$old_ifs
}

get_dbus

set_themes=$(python3 utils/get_themes.py)
set_themes=$(split_string $set_themes)
for set in $set_themes; do
    $(logout "set $set $1")
    $($set $1)
done

$(logout "-------finished-------")
