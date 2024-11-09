#!/bin/bash

set -e  # Завершити скрипт при будь-якій помилці

GREEN='\e[38;5;46m' 
YELLOW='\e[38;5;226m' 
RESET='\e[0m'

# 1. Перехід до директорії elixir
echo -e "${GREEN}====================================================${RESET}"
echo -e "${GREEN}Перехід до директорії elixir...${RESET}"
cd elixir || { echo -e "${YELLOW}Директорія elixir не знайдена${RESET}"; exit 1; }

echo -e "${GREEN}Видалення старих контейнерів elixir...${RESET}"
docker kill elixir && \ echo -e "${YELLOW}Контейнерів не знайдено${RESET}"
docker rm elixir && \

echo -e "${GREEN}Встановлюємо оновлення...${RESET}"
docker pull elixirprotocol/validator:testnet --platform linux/amd64 && \

echo -e "${GREEN}====================================================${RESET}"
echo -e "${GREEN}Ноду оновлено!Запуск..${RESET}"

echo -e "${GREEN}Запускаємо новий контейнер...${RESET}"
docker run --env-file /root/elixir/validator.env --platform linux/amd64 --name elixir -p 17690:17690 elixirprotocol/validator:testnet


