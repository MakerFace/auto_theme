#!/usr/bin/env bash

function check_failed() {
    if [ "" = $1 ]; then
        echo 'execute error'
    fi
}

crontab -l >./crontab.bak
exist=$(grep daynight ./crontab.bak)
# 不是空串，则表明crontab已经存在
if [ ! "" = "$exist" ]; then
    touch .init
    exit
fi

date_time=$(bash -c "python3 utils/date_time.py")
check_failed $?
themes=("light" "night")
i=0
for dt in $date_time; do
    times[$i]=$dt
    i=$((i + 1))
done

printf "%d %d * * * bash $PWD/daynight.sh %s > $PWD/daynight.log 2>&1\n" ${times[0]} ${times[1]} ${themes[1]} >>./crontab.bak
printf "%d %d * * * bash $PWD/daynight.sh %s > $PWD/daynight.log 2>&1\n" ${times[2]} ${times[3]} ${themes[2]} >>./crontab.bak

crontab ./crontab.bak
check_failed $?
