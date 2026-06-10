#!/bin/bash

SSH_FLAGS="-i $CLOUD_COMPUTER_INSTANCE_KEY_SECRET -o StrictHostKeyChecking=no -o ConnectTimeout=10"

if ! ssh $SSH_FLAGS "$CLOUD_YUSER@$CLOUD_COMPUTER_INSTANCE_NETWORK" "echo -e '\nOK\n'"; then
    echo "Ошибка: Не удалось подключиться к ВМ. Проверьте IP, ключ и правила Security Groups в Yandex Cloud"
    exit 1
fi

ssh $SSH_FLAGS "$CLOUD_YUSER@$CLOUD_COMPUTER_INSTANCE_NETWORK" << 'EOF'
    set -e # Остановить выполнение при любой ошибке
    
    cd ~/openvpn-ca/

    openvpn --genkey secret ta.key

    sudo cp ~/openvpn-ca/pki/ca.crt \
        ~/openvpn-ca/pki/issued/server.crt \
        ~/openvpn-ca/pki/private/server.key \
        ~/openvpn-ca/ta.key \
        /etc/openvpn/server/

    sudo touch /etc/openvpn/server/server.conf

    echo 'port 1194' | sudo tee -a /etc/openvpn/server/server.conf
    echo 'proto udp' | sudo tee -a /etc/openvpn/server/server.conf
    echo 'dev tun' | sudo tee -a /etc/openvpn/server/server.conf
    echo 'ca ca.crt' | sudo tee -a /etc/openvpn/server/server.conf
    echo 'cert server.crt' | sudo tee -a /etc/openvpn/server/server.conf
    echo 'key server.key' | sudo tee -a /etc/openvpn/server/server.conf
    echo 'cipher AES-256-GCM' | sudo tee -a /etc/openvpn/server/server.conf
    echo 'auth SHA512' | sudo tee -a /etc/openvpn/server/server.conf
    echo 'topology subnet' | sudo tee -a /etc/openvpn/server/server.conf
    echo 'server 10.8.0.0 255.255.255.0' | sudo tee -a /etc/openvpn/server/server.conf
    echo 'ifconfig-pool-persist /var/log/openvpn/ipp.txt' | sudo tee -a /etc/openvpn/server/server.conf
    echo 'push "redirect-gateway def1 bypass-dhcp"' | sudo tee -a /etc/openvpn/server/server.conf
    echo 'push "dhcp-option DNS 77.88.8.8"' | sudo tee -a /etc/openvpn/server/server.conf
    echo 'push "dhcp-option DNS 77.88.8.1"' | sudo tee -a /etc/openvpn/server/server.conf
    echo 'dh none' | sudo tee -a /etc/openvpn/server/server.conf
    echo 'keepalive 10 120' | sudo tee -a /etc/openvpn/server/server.conf
    echo 'tls-crypt ta.key' | sudo tee -a /etc/openvpn/server/server.conf
    echo 'user nobody' | sudo tee -a /etc/openvpn/server/server.conf
    echo 'group nogroup' | sudo tee -a /etc/openvpn/server/server.conf
    echo 'persist-key' | sudo tee -a /etc/openvpn/server/server.conf
    echo 'persist-tun' | sudo tee -a /etc/openvpn/server/server.conf
    echo 'status /var/log/openvpn/openvpn-status.log' | sudo tee -a /etc/openvpn/server/server.conf
    echo 'verb 3' | sudo tee -a /etc/openvpn/server/server.conf
    echo 'explicit-exit-notify 1' | sudo tee -a /etc/openvpn/server/server.conf

    echo "Сервис OpenVPN настроен!"
EOF
