#!/bin/bash

# DP-750 Lab Setup Script
# Creates an Azure Databricks Premium workspace in a randomly selected US region.

set -e

# Randomly select a deployment region.
REGIONS=(
  "westus2"
  "eastus2"
)

REGION="${REGIONS[$RANDOM % ${#REGIONS[@]}]}"

RESOURCE_GROUP="rg-dp750"
WORKSPACE_NAME="adb-dp750"

echo "Selected deployment region: $REGION"

echo "Installing az databricks extension..."
az config set core.collect_telemetry=no 2>/dev/null
az config set core.display_warnings=no 2>/dev/null
az config set extension.dynamic_install_allow_preview=true 2>/dev/null
az extension add --upgrade -n databricks

echo "Registering Microsoft.Databricks resource provider..."
az provider register \
  --namespace Microsoft.Databricks \
  --wait

echo "Creating resource group $RESOURCE_GROUP in region $REGION..."
az group create \
  --name "$RESOURCE_GROUP" \
  --location "$REGION"

echo "Creating Azure Databricks Premium workspace $WORKSPACE_NAME in $REGION..."
az databricks workspace create \
  --resource-group "$RESOURCE_GROUP" \
  --name "$WORKSPACE_NAME" \
  --location "$REGION" \
  --sku premium

echo "Installation done"
