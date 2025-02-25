# Azure Container Ecosystem (Az-204)

- ACR (Azure Container Registry)
- ACI (Azure Container Instance)
- ACA (Azure Conaitner Apps)

## ACR

For hosting the **images** of docker.

> **Service Tiers (also known as SKU references)**

**ACR** has three tiers available for use : **Basic, Standard** and **Premium**\
They have the same programmatic capabilities :
- such as **Microsoft Entra authentication** integration, **image deletion**, and **webhooks**

    - Basic

        The Basic tier is bes utilized for **development** and simple testing **workloads**.\
        Limites :

            - Single region support
            - No ability to utilize any private networking capabilities
            - Storage images (start with 10GB max to 20TB)
            - Read and write : 1,000 read ; 100 write operations per minute.
            - Upload and Download : 10 Mbps upload ; 30 download.
            - Allows only for tows webhook.

    - Standard

        Standard registries offer the same capabilities as Basic, with increased included storage and image throughput. Standard registries should satisfy the needs of most **production scenarios**.
    
    - Premium

        Premium registries provide the highest amount of included storage and concurrent operations, enabling high-volume scenarios. In addition to higher image throughput, Premium adds features such as **geo-replication** for managing a single registry across multiple regions, **content trust** for image tag signing, **private link with private endpoints** to restrict access to the registry.

        The Premium tier is the only choice **when you need to utilize private networking**. Additionally, the Premium tier **allows for leveraging regional availability zones or multi-regional scenarios**. Premium is also the only tier **where you can create your own encryption keys for your images**.

One of the nice things about the container registry is that no matter 
what tier you use, your images are **encrypted at rest**. If you want to enable 
the ability to use your own encryption key, you need to deploy in the 
Premium tier.