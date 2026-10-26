#!/bin/bash

while true; do
	STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080)
	if [ "$STATUS" -eq 200 ]; then
		echo "[OK] Сервер работает, код: $STATUS"
	else
		echo "$(date "+%Y-%m-%d %H:%M:%S") [ОШИБКА] Сервер упал, код: $STATUS" >> failures.log
	fi
	sleep 2
done
