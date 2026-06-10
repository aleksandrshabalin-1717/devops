#!/bin/bash

SSH_FLAGS="-i $CLOUD_COMPUTER_INSTANCE_KEY_SECRET -o StrictHostKeyChecking=no -o ConnectTimeout=10"

if ! ssh $SSH_FLAGS "$CLOUD_YUSER@$CLOUD_COMPUTER_INSTANCE_NETWORK" "echo -e '\nOK\n'"; then
    echo "Ошибка: Не удалось подключиться к ВМ. Проверьте IP, ключ и правила Security Groups в Yandex Cloud"
    exit 1
fi

ssh $SSH_FLAGS "$CLOUD_YUSER@$CLOUD_COMPUTER_INSTANCE_NETWORK" << 'EOF'
    set -e # Остановить выполнение при любой ошибке

    cp ~/openvpn-ca/pki/private/user_admin.key \
        ~/openvpn-ca/pki/ca.crt \
        ~/openvpn-ca/pki/issued/user_admin.crt \
        ~/openvpn-ca/ta.key \
        ~/clients/keys/

    echo "Ключи и сертификаты пользователя перенесены!"
EOF
