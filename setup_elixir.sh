#!/bin/bash

set -e 

ORANGE='\e[38;5;214m'  
GREEN='\e[38;5;46m' 
BOLD='\e[1m'         
RESET='\e[0m'           

echo -e "${ORANGE}${BOLD}====================================================${RESET}"
wget https://raw.githubusercontent.com/88n77/Logo-88n77/main/logo.sh
chmod +x logo.sh
./logo.sh

echo -e "${ORANGE}${BOLD}====================================================${RESET}"
echo -e "${ORANGE}${BOLD}Оновлення залежностей...${RESET}"
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl git jq lz4 build-essential unzip

echo -e "${ORANGE}${BOLD}====================================================${RESET}"
echo -e "${ORANGE}${BOLD}Встановлення Docker...${RESET}"
sudo apt install -y ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER

echo -e "${ORANGE}${BOLD}====================================================${RESET}"
echo -e "${ORANGE}${BOLD}Створення директорії для валідатора...${RESET}"
mkdir -p ~/elixir && cd ~/elixir

echo -e "${ORANGE}${BOLD}Завантаження файлу валідатора...${RESET}"
wget https://files.elixir.finance/validator.env

echo -e "${ORANGE}${BOLD}====================================================${RESET}"
echo -e "${ORANGE}${BOLD}Відкриття редактора для налаштування validator.env...${RESET}"
nano validator.env  # Відкриваємо nano для редагування

echo -e "${ORANGE}${BOLD}====================================================${RESET}"
echo -e "${ORANGE}${BOLD}Завантаження Docker-образу...${RESET}"
docker pull elixirprotocol/validator:v3

echo -e "${ORANGE}${BOLD}====================================================${RESET}"
echo -e "${ORANGE}${BOLD}Запуск валідатора...${RESET}"
docker run -d --env-file ~/elixir/validator.env --name elixir --platform linux/amd64 elixirprotocol/validator:v3

echo -e "${ORANGE}${BOLD}====================================================${RESET}"
echo -e "${ORANGE}${BOLD}Валідатор запущений. Перегляньте id контейнера за допомогою:${RESET}"
echo -e "${GREEN}${BOLD}docker container ls${RESET}"
