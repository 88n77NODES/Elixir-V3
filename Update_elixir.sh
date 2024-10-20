#!/bin/bash

set -e  # Завершити скрипт при будь-якій помилці

GREEN='\e[38;5;46m'  
RESET='\e[0m'

echo -e "${GREEN}====================================================${RESET}"
wget https://raw.githubusercontent.com/88n77/Logo-88n77/main/logo.sh
chmod +x logo.sh
./logo.sh

echo -e "${GREEN}====================================================${RESET}"
echo -e "${GREEN}Перехід до директорії elixir...${RESET}"
cd elixir || { echo -e "${GREEN}Директорія elixir не знайдена${RESET}"; exit 1; }

echo -e "${GREEN}====================================================${RESET}"
echo -e "${GREEN}Зупинка контейнерів elixir...${RESET}"
docker ps -a | grep elixir | awk '{print $1}' | xargs docker stop || echo -e "${GREEN}Контейнерів не знайдено${RESET}"

echo -e "${GREEN}====================================================${RESET}"
echo -e "${GREEN}Видалення контейнерів elixir...${RESET}"
docker ps -a | grep elixir | awk '{print $1}' | xargs docker rm || echo -e "${GREEN}Контейнерів не знайдено${RESET}"

echo -e "${GREEN}====================================================${RESET}"
echo -e "${GREEN}Завантаження нового Docker-образу...${RESET}"
docker pull elixirprotocol/validator:v3 --platform linux/amd64

echo -e "${GREEN}====================================================${RESET}"
echo -e "${GREEN}Запуск нового контейнера...${RESET}"
docker run --name elixir --env-file validator.env --platform linux/amd64 -p 17690:17690 --restart unless-stopped elixirprotocol/validator:v3

echo -e "${GREEN}====================================================${RESET}"
echo -e "${GREEN}Ноду оновлено!${RESET}"
