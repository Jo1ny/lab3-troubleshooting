#!/bin/bash

RESTART_COUNT=0
while true; do
	STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080)
	if [ "$STATUS" -eq 200 ]; then
		echo "[OK] Сервер работает, код: $STATUS"
		RESTART_COUNT=0
		sleep 2
	else	
		RESTART_COUNT=$((RESTART_COUNT + 1))
		echo "[ОШИБКА] Сервер упал, код: $STATUS. Попытка перезапуска: $RESTART_COUNT"
		echo "$(date "+%Y-%m-%d %H:%M:%S") [ОШИБКА] Код: $STATUS, попытка: $RESTART_COUNT"
		
		if [ "$RESTART_COUNT" -gt 3 ]; then
			echo "[КРИТИЧНО] 3 Неудачных попытки перезапуска! Завершаем работу."
			exit 1			
		fi
	
		echo "Перезапускаем api_backend..."
		docker compose restart api_backend
		sleep 5
	fi
done
