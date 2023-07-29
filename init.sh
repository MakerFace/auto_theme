#!/usr/bin/env bash

function check_failed() {
    if [ "" = $1 ]; then
        echo 'execute error'
    fi
}

crontab -l >./crontab.bak
exist=$(grep daydark ./crontab.bak)
# 不是空串，则表明crontab已经存在
if [ ! "" = "$exist" ]; then
    touch .init
    exit
fi

date_time=$(bash -c "python3 utils/date_time.py")
check_failed $?
themes=("light" "dark")
i=0
for dt in $date_time; do
    times[$i]=$dt
    i=$((i + 1))
done

# BUG bash 索引从0开始，zsh从1开始
printf "%d %d * * * bash $PWD/daydark.sh %s > $PWD/daydark.log 2>&1\n" ${times[0]} ${times[1]} ${themes[0]} >>./crontab.bak
printf "%d %d * * * bash $PWD/daydark.sh %s > $PWD/daydark.log 2>&1\n" ${times[2]} ${times[3]} ${themes[1]} >>./crontab.bak

mkdir -p $HOME/.local/share/systemd/user/
cp systemd/system/auto_theme.service $HOME/.local/share/systemd/user/
systemctl --user enable auto_theme

crontab ./crontab.bak
check_failed $?
