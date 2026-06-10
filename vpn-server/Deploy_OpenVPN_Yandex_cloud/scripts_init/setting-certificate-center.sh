#!/bin/bash

SSH_FLAGS="-i $CLOUD_COMPUTER_INSTANCE_KEY_SECRET -o StrictHostKeyChecking=no -o ConnectTimeout=10"

if ! ssh $SSH_FLAGS "$CLOUD_YUSER@$CLOUD_COMPUTER_INSTANCE_NETWORK" "echo -e '\nOK\n'"; then
    echo "Ошибка: Не удалось подключиться к ВМ. Проверьте IP, ключ и правила Security Groups в Yandex Cloud"
    exit 1
fi

ssh $SSH_FLAGS "$CLOUD_YUSER@$CLOUD_COMPUTER_INSTANCE_NETWORK" << 'EOF'
    set -e # Остановить выполнение при любой ошибке
    
    make-cadir ~/openvpn-ca
    cd ~/openvpn-ca/

    echo 'set_var EASYRSA_REQ_COUNTRY     "RU"' >> ./vars
    echo 'set_var EASYRSA_REQ_PROVINCE    "Moscow"' >> ./vars
    echo 'set_var EASYRSA_REQ_CITY        "Moscow City"' >> ./vars
    echo 'set_var EASYRSA_REQ_ORG         "Our Company Name"' >> ./vars
    echo 'set_var EASYRSA_REQ_EMAIL       "sysadmin@company.ru"' >> ./vars
    echo 'set_var EASYRSA_REQ_OU          "IT"' >> ./vars
    echo 'set_var EASYRSA_ALGO            "ec"' >> ./vars
    echo 'set_var EASYRSA_DIGEST          "sha512"' >> ./vars

    ./easyrsa init-pki

    mkdir -p ~/clients/keys ~/clients/files

    echo "§ Каталоги и конфиг центра серетификации успешно созданы!"
EOF
