#! /bin/bash

# Подлключаем конфигурацию
source ./config.sh

# Создаем инфраструктуры
source ./scripts_init/creation-infrastructure.sh

# Небольшая задержка, чтобы инстанс Yandex Cloud успел поднять SSH клиента
sleep 70

# Устанавливаем необходимые пакеты и создаём структуру каталогов
source ./scripts_init/add-dependencies.sh

sleep 15

# Настрока центра сертификации
source ./scripts_init/setting-certificate-center.sh
