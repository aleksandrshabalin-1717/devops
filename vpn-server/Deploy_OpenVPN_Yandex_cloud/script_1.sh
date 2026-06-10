#! /bin/bash

# Подлключаем конфигурацию
source ./config.sh

# Настраиваем и запускаем сервис OpenVPN
source ./scripts_setting_server/setting-openvpn.sh

sleep 15

# Настраиваем сеть
source ./scripts_setting_server/setting-network.sh

sleep 15

source ./scripts_setting_server/up_openvpn.sh
