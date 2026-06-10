#! /bin/bash

# Получение идентификатор облака
CLOUD_DATA=$(yc resource-manager cloud get "$CLOUD_NAME" \
    --format json 2>/dev/null)

if [ $? -ne 0 ]; then
    echo "Error: Ошибка получени \"ID\" по облаку \"'$CLOUD_NAME'\""
    exit 1
fi

CLOUD_ID=$(echo "$CLOUD_DATA" | jq -r '.id')

if [ -z "$CLOUD_ID" ] || [ "$CLOUD_ID" == "null" ]; then
    echo "Error: Ошибка получени \"ID\" облака \"$CLOUD_NAME\""
    exit 1
fi

echo "Cloud:"
echo "       name - '$CLOUD_NAME'"
echo "       id - '$CLOUD_ID'"
# .................

# Создание каталога, сети, подсети и виртуальной машины в облаке
# Создание директории
CLOUD_DIR_DATA=$(yc resource-manager folder create \
    --name "$CLOUD_DIR_NAME" \
    --cloud-id "$CLOUD_ID" \
    --format json  2>/dev/null)

if [ $? -ne 0 ]; then
    echo "Error: Ошибка создания каталога '$CLOUD_DIR_NAME'"
    exit 1
fi

CLOUD_DIR_ID=$(echo "$CLOUD_DIR_DATA" | jq -r '.id')

echo "Directory:"
echo "       name - '$CLOUD_DIR_NAME'"
echo "       id - '$CLOUD_DIR_ID'"

# Создание сети
CLOUD_NETWORK_DATA=$(yc vpc network create \
    --folder-id "$CLOUD_DIR_ID" \
    --name "$CLOUD_NETWORK_NAME" \
    --description "network for virtual private net" \
    --format json  2>/dev/null)

if [ $? -ne 0 ]; then
    echo "Error: Ошибка создания сети '$CLOUD_NETWORK_NAME'"
    exit 1
fi

CLOUD_NETWORK_ID=$(echo "$CLOUD_NETWORK_DATA" | jq -r '.id')

echo "Network:"
echo "       name - '$CLOUD_NETWORK_NAME'"
echo "       id - '$CLOUD_NETWORK_ID'"

# Создание подсети
CLOUD_SUB_NETWORK_DATA=$(yc vpc subnet create \
    --folder-id "$CLOUD_DIR_ID" \
    --name "$CLOUD_SUB_NETWORK_NAME" \
    --zone "$CLOUD_SUB_NETWORK_ZONE" \
    --range "$CLOUD_SUB_NETWORK_RANGE" \
    --network-name "$CLOUD_NETWORK_NAME" \
    --description "subnetwork for virtual private net" \
    --format json  2>/dev/null)

if [ $? -ne 0 ]; then
    echo "Error: Ошибка создания подсети '$CLOUD_SUB_NETWORK_NAME'"
    exit 1
fi

CLOUD_SUB_NETWORK_ID=$(echo "$CLOUD_SUB_NETWORK_DATA" | jq -r '.id')

echo "SubNetwork:"
echo "       name - '$CLOUD_SUB_NETWORK_NAME'"
echo "       id - '$CLOUD_SUB_NETWORK_ID'"

# Создание виртуальной машины
CLOUD_COMPUTER_INSTANCE_DATA=$(yc compute instance create \
    --folder-id "$CLOUD_DIR_ID" \
    --name "$CLOUD_COMPUTER_INSTANCE_NAME" \
    --network-interface subnet-id="$CLOUD_SUB_NETWORK_ID",nat-ip-version=ipv4 \
    --zone "$CLOUD_COMPUTER_INSTANCE_ZONE" \
    --create-boot-disk size=21,image-folder-id=standard-images,image-family=ubuntu-2404-lts \
    --ssh-key "$CLOUD_COMPUTER_INSTANCE_KEY" \
    --format json  2>/dev/null)

if [ $? -ne 0 ]; then
    echo "Error: Ошибка создания виртуальной машины '$CLOUD_COMPUTER_INSTANCE_NAME'"
    exit 1
fi

CLOUD_COMPUTER_INSTANCE_ID=$(echo "$CLOUD_COMPUTER_INSTANCE_DATA" | jq -r '.id')
CLOUD_COMPUTER_INSTANCE_LOCAL_NETWORK=$(echo "$CLOUD_COMPUTER_INSTANCE_DATA" | \
    jq -r '.network_interfaces[0].primary_v4_address.address')
CLOUD_COMPUTER_INSTANCE_NETWORK=$(echo "$CLOUD_COMPUTER_INSTANCE_DATA" | \
    jq -r '.network_interfaces[0].primary_v4_address.one_to_one_nat.address')

echo "Virtual machine:"
echo "       name - '$CLOUD_COMPUTER_INSTANCE_NAME'"
echo "       id - '$CLOUD_COMPUTER_INSTANCE_ID'"
echo "       IP - '$CLOUD_COMPUTER_INSTANCE_NETWORK'"
echo "       local IP - '$CLOUD_COMPUTER_INSTANCE_LOCAL_NETWORK'"
# .................
