#! /bin/sh

status=`pidof adm | wc -w`


if [ "$status" == "0" ];then
	echo 【警告】：adm进程未运行！ > /tmp/adm.log
else
	echo adm进程运行正常！共计"$status"个进程！ > /tmp/adm.log
fi
echo XU6J03M6 >> /tmp/adm.log
sleep 2
rm -rf /tmp/adm.log
