# IaaS

The section covers the following main topics :

1. Provisioning VMs in Azure
2. Exploring ARM templates
3. Understanding containers
4. Managing container images in Azure Container Registry (ACR)
5. Running container images in Azure Container Instances

## 1. Provisioning VMs in Azure

The following aspects should be considered before provisioning VMs :
- Availability
- Disks
- Limits
- Location
- Naming 
- Operating system image
- Post-provision configuration
- Size
- Pricing model

Availability
: You should avoid running a production workload on a single VM, as it wouldn’t be resilient in the face of planned or unplanned maintenance.

*French notes:*
Différence entre Availability Zone et Availability Set dans Azure:

1. La protée de la redondance :

