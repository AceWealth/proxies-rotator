#!/bin/bash
while :
do
	python /app/gimmeproxy.py >> /app/logs/rotatingproxy.log
	iptables -I INPUT -p tcp --dport $PORT 20020 -j DROP
	sleep 1
	python /app/parse_proxy_list.py
	service haproxy restart
	iptables -D INPUT -p tcp --dport $PORT 20020 -j DROP
	sleep 1800
done
