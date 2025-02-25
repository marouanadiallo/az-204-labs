# Creating a VM

As with other services in Azure, the availability of options can vary depending on **the region** you select. 

Most resources in Azure can be created in the **Azure portal**, via 
**PowerShell**, the **CLI**, the **REST APIs**, the **SDKs**, and using **ARM templates** or **Biceps**. 

The quicker and more efficient way to create VMs is **programmatically**, also providing you with the flexibility to create multiples at once should you need to. 

In the following exercises, we will create a **Windows Server 2019 Datacenter VM** and an **Ubuntu Server 24 VM**.

### Image URNs (URN stand for Uniform Resource Name)
----
We can easily find the **Windows Server 2019 Datacenter SKU** using the following Az CLI command :

*List all from **westeurope** region* :\
``` az vm image list --location westeurope --output table ```

*Filter by **Microsoft** and offer* :\
``` az vm image list --location westeurope --publisher MicrosoftWindowsServer --offer WindowsServer  --output table ```

*Filter by **Canonical** and offer* :\
``` az vm image list --location westeurope --publisher Canonical --offer ubuntu-24  --output table ```

**URN** has the following format : *Publisher:Offer:Sku:Version* (ex. Canonical:UbuntuServer:18.04-LTS:latest).\
**URN alias** some URN has alias, example:  (UbuntuLTS = Canonical:UbuntuServer:18.04-LTS:latest).

*Manage Azure subscription information command is *:\
```az account --help```

#### Create VM by using sh script
----
Checking the *createVM.sh* file.

*VM details*\
```az vm show --resource-group vmLab-rg-az204 --name ubunVm-weu-az204 ```\
```az vm show --resource-group vmLab-rg-az204 --name ubunVm-weu-az204 --query storageProfile.imageReference```

*Delete the resource group and all the resources we just deployed with the following* :\
```az group delete --name vmLab-rg-az204 -y```\
*-y (--yes) => for forcing*

#### ARM template structure
----
*Empty template*

```
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {},
    "functions": [],
    "variables": {},
    "resources": [],
    "outputs": {}
}
```

> **Notes** :
- **$schema (required)** :

    This element defines the location of the **schema** that describes the version of the template language to be used.
    - **deployementTemplate** => for resource group deployments.
    - **subscriptionDeploymentTemplate** => perform a subscription deployment.
    - **managementGroupDeploymentTemplate** => for management group deployments.
    - **tenantDeploymentTemplate** => for tenant deployments.
- **contentVersion (required)** :

    Defines the **schema** version to be used. 
- **parameters (opitonal)** :

    Allows to specify input parameters for the template to use.
- **functions (optional)** :

    Allows to create own functions for the template to use. Important : functions can't access template parameters, only the parameters defined by the function.
- **variable (optional)** : 

    Allows to create variables that the model can use.
- **resources (required)** :

    Define the resources that we want to deploy o update as part of the template deployement.
- **outputs (optional)** :

    Allows you to return values from deployed resources.

#### Deploying multiple resources
----
There are two approaches to deploying multiple resources – **multi-tiered templates** and **nested templates**. 
