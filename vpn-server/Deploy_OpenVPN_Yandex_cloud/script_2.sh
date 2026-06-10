#! /bin/bash

# Подлключаем конфигурацию
source ./config.sh

# Настройка конфига для файла "*.ovpn" клиента VPN
source ./scripts_setting_user/setting_user_config.sh

sleep 15

# Перенос файлов клиента в рабочую директорию
source ./scripts_setting_user/copy_client_files.sh

sleep 15

# Генерация файла для создания клиентских конфигов
source ./scripts_setting_user/create_make_config.sh

sleep 15

# Создание клиентского конфига
source ./scripts_setting_user/create_ovpn.sh
