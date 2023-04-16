#!/usr/bin/env bash
#! 注意bash和zsh的数组起始索引不一样！
# TODO 添加开机检测脚本，如果当前是白天，但是主题是黑色，就执行light主题
# 有两种方法可以实现，但都需要调用check脚本
#* 1. crontab: @reboot
#* 2. systemd: default.target

#* 获取主题配色
#* 返回值：0=light, 1=dark
function get_theme() {
    theme=$(gsettings get org.gnome.desktop.interface gtk-theme)
    res=$(echo $theme | grep -i 'light') #* 忽略大小写
    if [ "$res" != "" ]; then
        return 0
    else
        return 1
    fi
}

#* 获取当前时间在light还是dark区间
#* 返回值：0=light, 1=dark
function get_time() {
    cur_timestamp=$(date +%s)
    timestamps=($(crontab -l | awk '{print $2":"$1}' | xargs -I {} date -d {} +%s))                 #*(light dark)
    if [ $cur_timestamp -ge ${timestamps[0]} ] && [ $cur_timestamp -lt ${timestamps[1]} ]; then #* should be light theme
        return 0
    else
        return 1
    fi
}

workspace=$(
    cd "$(dirname "$0")"
    pwd
)
cd $workspace/..

get_time
ftime=$?
get_theme
ftheme=$?

echo "time is $ftime, theme is $ftheme"
if [ "$ftime" == "$ftheme" ]; then
    echo 'same theme'
else
    if [ "$ftime" == "0" ]; then
        # echo 'change to light theme'
        $PWD/daydark.sh light
    else
        # echo 'change to dark theme'
        $PWD/daydark.sh dark
    fi
fi
