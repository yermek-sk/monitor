#!/bin/bash

# Делаем быстрый замер перед отправкой приветствия
initial_ping=$(curl -o /dev/null -s -w "%{time_total}" https://www.google.com)

# Отправляем приветствие с текущим пингом
/usr/local/bin/send_alert.sh "Монитор запущен. Текущий пинг: ${initial_ping} сек."

alert_file="/tmp/alert_sent"

while true; do
    # Замер пинга
    ping_value=$(curl -o /dev/null -s -w "%{time_total}" https://www.google.com)
    echo "$(date): Ping is $ping_value"

    # Запись в БД
    PGPASSWORD="$DB_PASSWORD" /usr/bin/psql -h db -U "$DB_USER" -d "$DB_NAME" -c "INSERT INTO pings (val) VALUES ($ping_value);" 2>/dev/null

    # Проверка порога
    if (( $(echo "$ping_value > 1.0" | bc -l) )); then
        if [ ! -f "$alert_file" ]; then
            /usr/local/bin/send_alert.sh "Внимание! Высокий пинг: $ping_value сек."
            touch "$alert_file"
        fi
    else
        [ -f "$alert_file" ] && rm "$alert_file"
    fi

    sleep 60
done
