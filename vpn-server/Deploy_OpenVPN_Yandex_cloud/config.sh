#! /bin/bash

# Имя облака
CLOUD_NAME="cloud-aleks21-21-21"

# Данне для создания директории и сети
CLOUD_DIR_NAME="server-vpn"
CLOUD_NETWORK_NAME="network-vpn"

# Данные для создания подсети
CLOUD_SUB_NETWORK_NAME="sub-network-vpn"
CLOUD_SUB_NETWORK_ZONE="ru-central1-a"
CLOUD_SUB_NETWORK_RANGE="10.128.0.0/24"

# Данные для создания виртуальной машины
CLOUD_COMPUTER_INSTANCE_NAME="vm-vpn"
# должно совпадать с CLOUD_SUB_NETWORK_ZONE
CLOUD_COMPUTER_INSTANCE_ZONE="ru-central1-a"

# Ползователь виртуальной машины
CLOUD_YUSER="yc-user"
CLOUD_COMPUTER_INSTANCE_KEY="$HOME/.ssh/id_rsa.pub"
CLOUD_COMPUTER_INSTANCE_KEY_SECRET="$HOME/.ssh/id_rsa"

# Для настройки клиента VPN
CLIENT_USER_NAME="user_admin"
# В выводе после выполнения script_1.sh запомнить IP
CLOUD_COMPUTER_INSTANCE_NETWORK="89.169.131.83"
