#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status

# ==============================================================================
# DESCRIPTION:
# This script automates the creation of the Azure Remote Backend infra required
# for Terraform state tracking and runs the initial configuration.
#
# DEV REQUIREMENTS (CRUCIAL):
# Every developer MUST configure their own distinct blob storage parameters in 
# their local '.env' file before executing this script. This is being performed
# to avoid devs testing new terraform code in production. 
# DO NOT share the same STORAGE_ACCOUNT_NAME across different dev machines, as 
# doing so will cause team members to overwrite each other's active development
# state or fail because this name must be unique across Azure.
# This script allows you to initialize Terraform with your own isolated state
# parameters.
#
# IDEMPOTENCY:
# You can run this script MULTIPLE TIMES safely. If the resources already exist
# in Azure, it will verify them without destroying or re-creating anything.
# It is only required to successfully run ONCE to start developing.
#
# IMPORTANT NOTICE REGARDING .ENV CHANGES:
# If you modify your '.env' variables AFTER a successful run:
# - Changing STORAGE_ACCOUNT_NAME or STATE_KEY will force Terraform to look for
#   your infrastructure state in a different place.
# - If you do this, you must run this script again with the '-migrate-state' 
#   flag to safely move your tracking files to the new Azure remote location.
#
# NEXT STEPS AFTER SUCCESSFUL INITIALIZATION:
# Once this script finishes successfully, your working directory is fully locked
# and loaded. You do NOT need to re-run this setup for everyday tasks. You can 
# immediately proceed to execute standard deployment lifecycles:
# 1. 'terraform plan'    -> Preview what changes will happen in your Azure account.
# 2. 'terraform apply'   -> Deploy and build the actual infrastructure components.
# 3. 'terraform destroy' -> Wipe out your deployed infrastructure to save credits.
#                           Running destroy will NOT delete this tracking backend,
#                           so you can keep planning and applying safely afterward.
# ==============================================================================


# 1. Cargar las variables del archivo .env
if [ -f .env ]; then
    export $(cat .env | grep -v '#' | xargs)
else
    echo "Error: No se encontró el archivo .env. Por favor copia .env.example a .env y configúralo."
    exit 1
fi

echo "=================================================="
echo "  Verificando / Creando Backend State en Azure..."
echo "=================================================="
echo "      Ubicación: $AZURE_LOCATION_DEVOPS"
echo "      Resource Group: $RESOURCE_GROUP_NAME_DEVOPS"
echo "      Storage Account: $STORAGE_ACCOUNT_NAME_DEVOPS"
echo "      Container: $CONTAINER_NAME_DEVOPS"
echo "=================================================="

# 2. Crear el grupo de recursos estándar para operaciones
echo "Creando/verificando el grupo de recursos: $RESOURCE_GROUP_NAME_DEVOPS en la ubicación: $AZURE_LOCATION_DEVOPS"
az group create --name "$RESOURCE_GROUP_NAME_DEVOPS" --location "$AZURE_LOCATION_DEVOPS"

# 3. Crear la cuenta de almacenamiento usando la variable del .env
echo "Creando/verificando la cuenta de almacenamiento: $STORAGE_ACCOUNT_NAME_DEVOPS"
az storage account create --resource-group "$RESOURCE_GROUP_NAME_DEVOPS" --name "$STORAGE_ACCOUNT_NAME_DEVOPS" --sku Standard_LRS --encryption-services blob

# 4. Crear el contenedor de blobs
echo "Creando/verificando el contenedor de blobs: $CONTAINER_NAME_DEVOPS"
az storage container create --name "$CONTAINER_NAME_DEVOPS" --account-name "$STORAGE_ACCOUNT_NAME_DEVOPS"

echo -e "Backend State en Azure verificado/creado con éxito!"
echo "=================================================="
echo "  Inicializando Terraform con Backend Dinámico..."
echo "=================================================="

# 5. Inicializar Terraform inyectando TODOS los parámetros desde el .env
terraform init -backend-config="resource_group_name=$RESOURCE_GROUP_NAME_DEVOPS" -backend-config="storage_account_name=$STORAGE_ACCOUNT_NAME_DEVOPS" -backend-config="container_name=$CONTAINER_NAME_DEVOPS" -backend-config="key=$STATE_KEY_DEVOPS" -migrate-state -input=false

echo -e " ¡Ambiente inicializado y listo para usar!"