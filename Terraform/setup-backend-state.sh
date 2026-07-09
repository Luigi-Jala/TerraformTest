#!/bin/bash

# 1. Cargar las variables del archivo .env
if [ -f .env ]; then
    export $(cat .env | grep -v '#' | xargs)
else
    echo "Error: No se encontró el archivo .env"
    exit 1
fi

echo "Creando el Terraform backend state usando la cuenta de almacenamiento: $STORAGE_ACCOUNT_NAME"

# 2. Crear el grupo de recursos estándar para operaciones
az group create --name quizarena-ops-rg --location centralus

# 3. Crear la cuenta de almacenamiento usando la variable del .env
az storage account create \
  --resource-group quizarena-ops-rg \
  --name "$STORAGE_ACCOUNT_NAME" \
  --sku Standard_LRS \
  --encryption-services blob

# 4. Crear el contenedor de blobs
az storage container create \
  --name terraform-state \
  --account-name "$STORAGE_ACCOUNT_NAME"

echo "¡Backend State de Azure creado con éxito!"