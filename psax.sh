#!/bin/bash
echo "PID     TTY     STAT     TIME     COMMAND" # выведем заголовок
for ITEM in `ls -l /proc | awk '{ print $9 }' | grep -Eo '[0-9]{1,4}'| sort -n | uniq`
do
if [ -d /proc/$ITEM/ ]; then  # дополнительное условие проверки существования процесса
  v_PID=`cat /proc/$ITEM/stat | awk '{ print $1 }'`
  v_TTY=`ps -p $ITEM -o tty`
  v_STAT=`cat /proc/$ITEM/stat | awk '{ print $3 }'`
  v_UTIME=`cat /proc/$ITEM/stat | awk '{ print $14 }'`
  v_STIME=`cat /proc/$ITEM/stat | awk '{ print $15 }'`
  v_CLKTCK=`getconf CLK_TCK`
  v_FULLTIME=$((v_UTIME+v_STIME))
  v_CPUTIME=$((v_FULLTIME/v_CLKTCK))
  v_TIME=`date -u -d @${v_CPUTIME} +"%T"`

  v_COMMAND=`cat /proc/$ITEM/cmdline | strings -n 1 | tr '\n' ' '`
  if [[ -z $v_COMMAND ]]; then v_COMMAND=`cat /proc/$ITEM/stat | awk '{ print $2 }'`; fi

  echo "$v_PID     ${v_TTY:3}     $v_STAT     $v_TIME     $v_COMMAND"
fi
done
