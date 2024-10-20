#!/bin/bash

set -e  # Завершити скрипт при будь-якій помилці

GREEN='\e[38;5;46m' 
YELLOW='\e[38;5;226m'
RESET='\e[0m'

echo "===================================================="
wget https://raw.githubusercontent.com/88n77/Logo-88n77/main/logo.sh
chmod +x logo.sh
./logo.sh

echo -e "${GREEN}====================================================${RESET}"
echo -e "${GREEN}Оновлення залежностей...${RESET}"
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl git jq lz4 build-essential unzip

echo -e "${GREEN}====================================================${RESET}"
echo -e "${GREEN}Встановлення Docker...${RESET}"
sudo apt install -y ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=\$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker \$USER
newgrp docker

echo -e "${GREEN}====================================================${RESET}"
echo -e "${GREEN}Створення директорії для валідатора...${RESET}"
mkdir -p ~/elixir && cd ~/elixir

echo -e "${GREEN}Завантаження файлу валідатора...${RESET}"
wget https://files.elixir.finance/validator.env

echo -e "${GREEN}====================================================${RESET}"
echo -e "${GREEN}Відкриття редактора для налаштування validator.env...${RESET}"
# Відкриваємо nano для редагування validator.env
sudo apt install -y nano
nano validator.env

# Продовжуємо після закриття редактора
echo -e "${GREEN}====================================================${RESET}"
echo -e "${GREEN}Завантаження Docker-образу...${RESET}"
docker pull elixirprotocol/validator:v3

echo -e "${GREEN}====================================================${RESET}"
echo -e "${GREEN}Запуск валідатора...${RESET}"
docker run -d --env-file ~/elixir/validator.env --name elixir --platform linux/amd64 elixirprotocol/validator:v3

echo -e "${GREEN}====================================================${RESET}"
echo -e "${YELLOW}Валідатор запущений.${RESET}"
