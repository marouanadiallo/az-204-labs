#!/bin/bash

# Variables
resourceGroup="vmLab-rg-az204"
location="westeurope"
winVmName="winVm-weu-az204"
winURN="MicrosoftWindowsServer:WindowsServer:2019-datacenter:latest"
ubuntuVmName="ubunVm-weu-az204"
ubuntuURN="Canonical:ubuntu-24_04-lts:server:latest"
vmSize="Standard_B1s"
text="Hello, World!"
user_data=$(echo -n "$text" | iconv -t UTF-16LE | base64 -w0)
credencials="--admin-username $username --admin-password $password"
tags="envLab=az204"

#Get credentials
read -p "Enter admin username: " username
read -sp "Enter admin password: " password
echo

# Create resource group
az group create --name $resourceGroup --location $location --tags $tags

# Create Windows VM
az vm create \
    --resource-group $resourceGroup \
    --name $winVmName \
    --image $winURN \
    --size $vmSize \
    --tags $tags \
    --user-data $user_data \
    --admin-username $username \
    --admin-password $password

# Create Ubuntu VM
az vm create \
    --resource-group $resourceGroup \
    --name $ubuntuVmName \
    --image $ubuntuURN \
    --size $vmSize \
    --tags $tags \
    --user-data $user_data \
    --admin-username $username \
    --admin-password $password