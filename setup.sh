#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Ошибка: скрипт должен быть запущен с правами root." 
  exit 1
fi

echo "Настройка UFW"
if ! command -v ufw &> /dev/null; then
    if command -v apt &> /dev/null; then
        apt update && apt install -y ufw
    elif command -v pacman &> /dev/null; then
        pacman -Sy --noconfirm ufw
    fi
fi

echo "Открытие портов"
PORTS=(22 23 80 443 444 445 446 447 448 449 450 8443)

for PORT in "${PORTS[@]}"; do
    echo "Открываем порт: $PORT/tcp"
    ufw allow "$PORT"/tcp
done

echo "Включение UFw"
ufw --force enable

echo "Проверка UFW"
ufw status verbose

echo "Установка 3x-UI"
bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh) < /dev/tty
