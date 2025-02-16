# Creating a VM

As with other services in Azure, the availability of options can vary depending on **the region** you select. 

Most resources in Azure can be created in the **Azure portal**, via 
**PowerShell**, the **CLI**, the **REST APIs**, the **SDKs**, and using **ARM templates** or **Biceps**. 

The quicker and more efficient way to create VMs is **programmatically**, also providing you with the flexibility to create multiples at once should you need to. 

In the following exercises, we will create a **Windows Server 2019 Datacenter VM** and an **Ubuntu Server 19.04 VM**.

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

