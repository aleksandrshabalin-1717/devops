#!/bin/bash

SSH_FLAGS="-i $CLOUD_COMPUTER_INSTANCE_KEY_SECRET -o StrictHostKeyChecking=no -o ConnectTimeout=10"

if ! ssh $SSH_FLAGS "$CLOUD_YUSER@$CLOUD_COMPUTER_INSTANCE_NETWORK" "echo -e '\nOK\n'"; then
    echo "Ошибка: Не удалось подключиться к ВМ. Проверьте IP, ключ и правила Security Groups в Yandex Cloud"
    exit 1
fi

ssh $SSH_FLAGS "$CLOUD_YUSER@$CLOUD_COMPUTER_INSTANCE_NETWORK" << 'EOF'
    set -e # Остановить выполнение при любой ошибке
    echo -e "§ Добро пожаловать!\n"
   
    sudo apt update -y
    echo -e "\n§ Кэш пакетов APT успешно синхронизирован"

    sudo DEBIAN_FRONTEND=noninteractive apt install firewalld easy-rsa openvpn -y
    echo -e "\n§ Пакеты: firewalld, easy-rsa, openvpn, успешно установлены!\n"
EOF
