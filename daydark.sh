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

source 'utils/log.sh'

function executor() {
    $1 | tee -a daydark.log
}

function get_ubuntu() {
    version=$(lsb_release -a | awk '{print $2}'|head -n4 |tail -n1)
    if [ $version == '22.04' ]; then
        return 2;
    else
        return 0;
    fi
}

function gnome() {
    # TODO add color-scheme on Ubuntu22.04
    
    # gsettings set org.gnome.desktop.interface color-scheme "prefer-light"
    # gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
    theme=$(executor "python3 utils/read_config.py gnome theme $1")
    cursor=$(executor "python3 utils/read_config.py gnome cursor $1")
    terminal=$(executor "python3 utils/read_config.py gnome terminal $1")
    shell=$(executor "python3 utils/read_config.py gnome shell $1")

    $(logout 'gnome setting')

    gsettings set org.gnome.desktop.interface color-scheme "prefer-$1"
    $(logout "setting color-scheme prefer-$1")

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

function terminator() {
    # FIXME 必须关闭所有的终端才生效
    res=$(executor "python3 terminator/lightdark.py terminator theme $1")
    $(logout "setting terminator theme $res")
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

echo '--------begin--------' >> daydark.log
get_dbus

set_themes=$(executor "python3 utils/get_themes.py")
set_themes=$(executor "split_string $set_themes")
for set in $set_themes; do
    $(logout "set $set $1")
    $($set $1)
done

$(logout "-------finished-------")
