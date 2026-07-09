#!/bin/bash
if [ -f .env ]; then
    export $(cat .env | grep -v '#' | xargs)
    terraform init -backend-config="storage_account_name=$STORAGE_ACCOUNT_NAME"
else
    echo "Error: No se encontró el archivo .env"
fi