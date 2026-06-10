#!/bin/bash

SSH_FLAGS="-i $CLOUD_COMPUTER_INSTANCE_KEY_SECRET -o StrictHostKeyChecking=no -o ConnectTimeout=10"

if ! ssh $SSH_FLAGS "$CLOUD_YUSER@$CLOUD_COMPUTER_INSTANCE_NETWORK" "echo -e '\nOK\n'"; then
    echo "Ошибка: Не удалось подключиться к ВМ. Проверьте IP, ключ и правила Security Groups в Yandex Cloud"
    exit 1
fi

ssh $SSH_FLAGS "$CLOUD_YUSER@$CLOUD_COMPUTER_INSTANCE_NETWORK" << 'EOF'
    set -e # Остановить выполнение при любой ошибке
    
    sudo sysctl -w net.ipv4.ip_forward=1
    echo "net.ipv4.ip_forward = 1" | sudo tee -a /etc/sysctl.conf

    sudo firewall-cmd --zone=public --add-port=1194/tcp --permanent
    sudo firewall-cmd --zone=public --add-service=openvpn --permanent
    sudo firewall-cmd --zone=trusted --add-interface=tun+ --permanent
    sudo firewall-cmd --zone=public --add-masquerade --permanent

    sudo firewall-cmd --reload

    echo "Firewall настроен и запущен!"
EOF
