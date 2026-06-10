#!/bin/bash

SSH_FLAGS="-i $CLOUD_COMPUTER_INSTANCE_KEY_SECRET -o StrictHostKeyChecking=no -o ConnectTimeout=10"

if ! ssh $SSH_FLAGS "$CLOUD_YUSER@$CLOUD_COMPUTER_INSTANCE_NETWORK" "echo -e '\nOK\n'"; then
    echo "Ошибка: Не удалось подключиться к ВМ. Проверьте IP, ключ и правила Security Groups в Yandex Cloud"
    exit 1
fi

# TODO Конфиги для MacOS Linux Windows немоного различаются 
    # TODO Добавить условия для Windows и Linux

ssh $SSH_FLAGS "$CLOUD_YUSER@$CLOUD_COMPUTER_INSTANCE_NETWORK" << EOF
    set -e # Остановить выполнение при любой ошибке

    cat > ~/clients/base.conf << INNER_EOF
client
dev tun
proto udp
remote $CLOUD_COMPUTER_INSTANCE_NETWORK 1194
resolv-retry infinite
nobind
persist-key
persist-tun
remote-cert-tls server
cipher AES-256-GCM
auth SHA512
;tls-crypt ta.key
verb 3
INNER_EOF

    echo "Конфиг клиента OpenVPN создан!"
EOF
