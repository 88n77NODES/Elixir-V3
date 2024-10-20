#!/bin/bash

set -e  # Завершити скрипт при будь-якій помилці

GREEN='\e[38;5;46m' 
YELLOW='\e[38;5;226m' 
RESET='\e[0m'

# Вивід логотипу
echo -e "${GREEN}====================================================${RESET}"
wget https://raw.githubusercontent.com/88n77/Logo-88n77/main/logo.sh
chmod +x logo.sh
./logo.sh

# 1. Перехід до директорії elixir
echo -e "${GREEN}====================================================${RESET}"
echo -e "${GREEN}Перехід до директорії elixir...${RESET}"
cd elixir || { echo -e "${YELLOW}Директорія elixir не знайдена${RESET}"; exit 1; }

# 2. Зупинка контейнерів elixir
echo -e "${GREEN}Зупинка контейнерів elixir...${RESET}"
docker ps -a | grep elixir | awk '{print $1}' | xargs docker stop || echo -e "${YELLOW}Контейнерів не знайдено${RESET}"

# 3. Видалення старих контейнерів elixir
echo -e "${GREEN}Видалення старих контейнерів elixir...${RESET}"
docker ps -a | grep elixir | awk '{print $1}' | xargs docker rm || echo -e "${YELLOW}Контейнерів не знайдено${RESET}"

# 4. Завантаження нового Docker-образу
echo -e "${GREEN}Встановлюємо оновлення...${RESET}"
docker pull elixirprotocol/validator:v3 --platform linux/amd64

# 5. Запуск нового контейнера
echo -e "${GREEN}Запускаємо новий контейнер...${RESET}"
docker run --name elixir --env-file validator.env --platform linux/amd64 -p 17690:17690 --restart unless-stopped elixirprotocol/validator:v3

echo -e "${GREEN}====================================================${RESET}"
echo -e "${GREEN}Ноду оновлено!${RESET}"
