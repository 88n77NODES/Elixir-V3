#!/bin/bash

set -e  # Завершити скрипт при будь-якій помилці

# Визначаємо кольори
GREEN='\e[38;5;46m'    
YELLOW='\e[38;5;226m'  
BOLD='\e[1m'
RESET='\e[0m'

wget https://raw.githubusercontent.com/88n77/Logo-88n77/main/logo.sh
chmod +x logo.sh
./logo.sh

echo -e "${GREEN}${BOLD}====================================================${RESET}"
echo -e "${GREEN}${BOLD}Оновлення залежностей...${RESET}"
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl git jq lz4 build-essential unzip

echo -e "${GREEN}${BOLD}====================================================${RESET}"
echo -e "${GREEN}${BOLD}Встановлення Docker...${RESET}"
sudo apt install -y ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER

echo "newgrp docker"

echo -e "${GREEN}${BOLD}====================================================${RESET}"
echo -e "${GREEN}${BOLD}Створення директорії для валідатора...${RESET}"
mkdir -p ~/elixir && cd ~/elixir

echo -e "${GREEN}${BOLD}Завантаження файлу валідатора...${RESET}"
wget https://files.elixir.finance/validator.env

echo -e "${GREEN}${BOLD}====================================================${RESET}"
echo -e "${GREEN}${BOLD}Відкриття редактора для налаштування validator.env...${RESET}"
nano validator.env  # Відкриваємо nano для редагування

echo -e "${GREEN}${BOLD}====================================================${RESET}"
echo -e "${GREEN}${BOLD}Завантаження Docker-образу...${RESET}"
docker pull elixirprotocol/validator:v3

echo -e "${GREEN}${BOLD}====================================================${RESET}"
echo -e "${GREEN}${BOLD}Запуск валідатора...${RESET}"
docker run -d --env-file ~/elixir/validator.env --name elixir --platform linux/amd64 elixirprotocol/validator:v3

echo -e "${GREEN}${BOLD}====================================================${RESET}"
echo -e "${GREEN}${BOLD}Валідатор запущений. Перегляньте id контейнера за допомогою:${RESET}"
echo -e "${YELLOW}${BOLD}docker container ls${RESET}"
