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

# automatic initialize crontab
if [ ! -f .init ]; then
    echo 'initialize crontab'
    $(bash init.sh)
fi
function logout() {
    echo $1 >>daynight.log
}

function executor() {
    $1 | tee -a daynight.log
}

function gnome() {
    theme=$(executor "python3 utils/read_config.py gnome theme $1")
    cursor=$(executor "python3 utils/read_config.py gnome cursor $1")
    terminal=$(executor "python3 utils/read_config.py gnome terminal $1")
    shell=$(executor "python3 utils/read_config.py gnome shell $1")
    terminal_color="light"
    if [ $1 = "night" ];then
        terminal_color="dark"
    fi

    $(logout 'gnome setting')
    gsettings set org.gnome.desktop.interface gtk-theme "$theme"
    $(logout "setting gtk-theme $theme")
    gsettings set org.gnome.desktop.interface cursor-theme "$cursor"
    $(logout "setting cursor-theme $cursor")
    gsettings set org.gnome.shell.extensions.user-theme name "$shell"
    $(logout "setting shell-theme $shell")
    gsettings set org.gnome.Terminal.Legacy.Settings theme-variant "$terminal_color"
    gsettings set org.gnome.Terminal.ProfilesList default "$terminal"
    $(logout "setting terminal-theme $terminal")
    $(logout "----------------------")
}

function vscode() {
    res=$(executor "python3 vscode/lightdark.py vscode theme $1")
    $(logout "setting vscode theme $res")
    $(logout "----------------------")
}

function vim() {
    $(executor "python utils/change_config.py vim theme $1")
    $(logout "setting vim theme")
    $(logout "----------------------")
}

function spaceVim() {
    $(executor "python utils/change_config.py spaceVim theme $1")
    $(logout "setting spaceVim theme")
    $(logout "----------------------")
}

function update_time() {
    date_time=$(executor "python3 utils/date_time.py")
    crontab -l >/tmp/crontab.bak
    $(executor "python3 utils/change_crontab.py $date_time")
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

echo '--------begin--------' >daynight.log
get_dbus

set_themes=$(executor "python3 utils/get_themes.py")
set_themes=$(executor "split_string $set_themes")
for set in $set_themes; do
    $(logout "set $set $1")
    $($set $1)
done

$(logout "-------finished-------")
