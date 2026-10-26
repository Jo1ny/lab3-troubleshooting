# Incident Report: Troubleshooting 502 Bad Gateway (Nginx + Python Backend)

### Симптомы
- Запрос `curl -i http://localhost:8000` возвращал `HTTP/1.1 502 Bad Gateway`.
- Пользователи не получали ответа от сервиса.

### Диагностика
1. Проверка состояния контейнеров:
	`docker compose ps` показал, что оба сервиса (`web` и `api_backend`) находятся в статусе `up`
2. Анализ логов обратного прокси (Nginx):
	`docker compose logs web` выявил критическую ошибку: 
	`connect() failed (111: Connection refused) while connecting to upstream, upstream: "http://172.23.0.2:5000/"`.
3. Анализ бэкенда:
	в `docker-compose.yml` команда запуска использовала порт `8000` (`python -m http.server 8000`), в то время как Nginx пытался проксировать трафик на порт `5000`.

### Решение
1. В `nginx.conf` скорректирована директива `proxy_pass http://api_backend:8000;`.
2. Конфигурация Nginx обновлена без даунтайма: `docker compose exec web nginx -s reload`.
3. Контрольная проверка: `curl -i http://localhost:8080` возвращает `HTTP/1.1 200 OK`. Логи `api_backend` зафиксировали успешную обработку входящего запроса.
