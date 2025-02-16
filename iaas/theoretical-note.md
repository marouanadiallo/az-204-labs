# IaaS

The section covers the following main topics :

1. Provisioning VMs in Azure
2. Exploring ARM templates
3. Understanding containers
4. Managing container images in Azure Container Registry (ACR)
5. Running container images in Azure Container Instances

### 1. Provisioning VMs in Azure

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

#### Availability
-----
You should avoid running a production workload on a single VM, as it wouldn’t be resilient in the face of planned or unplanned maintenance.

> *French notes :*

Différence entre **Availability Zone** et **Availability Set** dans Azure:

1. La protée de la redondance :
    - **Availability set** :
        - Opère **au sein d'un même datacenter** Azure.
        - Répartit les VMs sur des **domaines d'erreur (fault domains)** et **domaines de mise à jour (update domains)**.
        - **Domaine d'erreur** : 

            Groupes de matériel partageant une source d'alimentation/switch réseau(ex: rack). En ca de panne matérielle, seuls les VMs du domaine affecté sont impactés.
        - **Domaine de mise à jour** : 

            Groupe de VMs redémarrés séquentiellement lors de mises à jour Azure (évite les interruptions simultanées).
    - **Availability Zone** :
        - S'étend sur **plusieurs datacenters physiques distincts** (au moins 3) **dans une même région Azure**.
        - Chaque zone dispose de son propre alimentation, refroidissement et réseau. Cela protège contre les pannes à l'échelle d'un datacenter entier (ex: catastrophe locale).
2. Niveau de résilience :
    - **Availability set** : 
        - Résilience interne au datacenter (pannes matérielles, maintenance planifiée).
        - **SLA : 99,94%** de disponibilité avec >= 2 VMs.
    - **Availability Zone** :
        - Résilience inter-datacenters (catastrophes majeures, pannes électriques).
        - **SLA : 99,99%** de disponibilité avec >= 2 VMs réparties sur >= 2 zones.
3. Configuration :
    - **Availability set** :

        - Créé lors du péploiement des VMs. Azure gère automatiquement la répartition.
        - Pas de choix manuel des domaines d'erreur/mise à jour.
    - **Availability zone** :

        - Choix explicite de la zone (1, 2 ou 3) pour chaque VM lors du déploiement.
        - Requiert une gestion manuelle de la répartition (ex. équilibrer les VMs sur 2 zones minimun).
4. Cas d'usage :
    - **Privilégiez les Availability Zone** si :

        - Votre région Azure les prend en charge.
        - Vous avez besoin de la résilience maximale (SLA 99,99%).
        - Exemples : Applications critiques (banque, santé).
    - **Utilisez les Availability Sets** si :

        - Les zones ne sont pas disponibles dans votre région.
        - Vous ne nécessitez pas de protection contre les pannes de datacenter entier.
        - Exemples: Applications moins critiques, budgets limités.
5. Compatibilité :
    - **Exclusivité** : 

        Une VM ne peut appartenir **ni aux deux simultanément** ni à plusieurs Availability Sets.
    - **Disponibilité** : 

        Les zones existent dans les régions Azure modernes (ex.: France centre, Europe Ouest), pas dans toutes.

#### Virtual Machine Scale Sets (VMSS)

**VMSS** est un service Azure conçu pour gérer des **groupes de machines virtuelles identiques** avec **mise à l'échelle automatique** et **équilibrage de charge**.

1. Principales caractéristiques des VMSS:
    - **Mise à l'échelle automatique** :

        Ajoute/supprime dynamiquement des VMs en fonction de la charge (CPU, mémoire, requêtes réseau, etc.)
    - **Orchestration centralisée** :

        Déploiement, configuration et gestion uniforme des VMs (image unique, extensions, mise à jour en rolling update).
    - **Intégration native** avec des services Azure :

        - Equilibreur de charge (Load Balancer)
        - Azure Monitor (métriques de scaling)
        - Azure Automanage (optimisation automatique).
2. Comaparaision avec Availability Zones/Sets

| Critère | VM Scale Sets | Availability Set | Availability Zone |
| ------- | ------------- | ---------------- | ----------------- |
| **Objectif principal** | Scaling horizontal et gestion centralisée | Haute disponibilité intra-datacenter | Haute disponibilité inter-datacenter |
| **Redondance** | Opérationnelle (dépends de la config) | Oui (fault/updating domains) | Oui (Zones physiques distinctes) |
| **Scaling automatique** | **Oui** | Non | Non |
| **Architecture** | Groupe homogène de VMs (stateless) | VMs homogène ou hétérogènes | VMs homogène ou hétérogènes | 
| **SLA** |   99,95% (Av Set) et 99,99% (Av Zone) | 99,95% (si >= 2 VMs) | 99,99% (si >= 2 VMs réparties sur deux zones) |

3. Complémentarité avec Availability Zones/Sets

Les **VMSS** peuvent combiner les avantages des **Zones/Sets** pour allier **scaling** et **haute disponibilité** :

- **Avec Availability Zones** :

    Déployez des instances de **VMSS sur plusieurs zones** => résilience contre les pannes de datacenter + scaling automatique.
- **Avec Availability Set** :

    Répartissez les instances de **VMSS sur des fault/update domains** (dans des région sans zones) => protection contre les pannes matérielles locales.

4. Cas d'usage typiques des **VMSS**

    - **App cloud-native** :

        Backend d'API, microservices, conteneurs (ex: kubernetes via AKS)
    - **Workloads stateless** :

        Traitement par lots (batch processing), calculs parallèles.
    - **Scaling réatif** :

        Sites avec pics de trafic (e-commerce, médias en direct).

> *NB* : 

**VMSS != Availability Zones/Sets** :

Les **VMSS** se focalisent sur le **scaling/gestion**, tandis que les **Zones/Sets** garantissent la **disponibilité**.

Nous pouvons également combiner un **Ensemble de disponibilité (Availability Set)** ou une **Zone de disponibilité (Availability Zone)** avec un **Azure Load Balancer** afin d'améliorer la résilience de votre application.

#### Disks
-----
When it comes to disks, there are two main considerations – **disk type** and **disk storage**. 

> Disk types : **Standard** (for dev and test env) and **Premium** (for prod env).

> Disk storage : **Managed Disk** (by Azure) and **Unmanaged Disks** (by you). 

#### Limits
-----
Bear in mind that there is a limit to the number of VMs a subscription can have per region, and a fixed quota of vCPUs (virtual Central Processing Units). But it is possible to request support to increase this limit, especially for vCPUs.

#### Location (or region)
-----
In the context of a VM, the location is also where the virtual disks will be created.

#### Naming
-----
The name is more than just an identifier within Azure – the name of a VM is used as the hostname as well. Changing the names of VMs after provisioning isn’t a trivial task, so the name should be considered carefully before you create the VM.

#### Operating system image
-----
Azure offers a variety of different operating system images that you can select to have installed on 
the VM during provisioning, both from the Windows and Linux families.

**Azure Marketplace images** are defined within a categorization hierarchy :

> A **publisher** contains one or more **offers**, and an offer can contain one or 
more **stock keeping units (SKUs)**, which can have one or more **versions** (the latest can usually also 
be selected for the version).

Get the locations list and details of images available per region using the **Azure CLI** :

```
az account list-locations --query [].name -o tsv 
az vm image list-publishers --location 'westeurope' --query [].name -o tsv
```
>  The --query option excepts **JMESPath** query string. See http://jmespath.org/ for more information.\
The -o (--output) option excepts Output format.  Allowed values : *json, jsonc, none, table, tsv, yaml, yamlc*.  **Default: json**.

#### Post-provision configuration
----
While **ARM templates** can provide **desired state deployment**, the configuration state of the deployed 
VM is not managed by ARM and can be managed through DSC. See the Further reading section for 
further information on DSC. Azure also supports cloud-init (https://cloud-init.io/) for 
most Linux distributions that support it.

#### Size
----
With Azure VMs, you don’t define the specifications for individual components such as processor, 
storage, or memory separately.  Instead, Azure has the concept of **VM sizes**. 

To help you select an appropriate VM size, Microsoft provides a useful 
VMs selector tool (which can be found here: https://azure.microsoft.com/pricing/
 vm-selector), allowing you to answer some questions about your requirements before providing 
recommendations on size.

List all **sizes** and respective specification available in the **Westeurope** for example :

```
az vm list-sizes -l westeurope --output table
```

#### Pricing model
----
Another important point that should be considered before creating a VM is cost. There are two main 
costs for each VM : **storage** and **compute**. 

> *French notes* :

> Le stockage des données dans les **disques durs virtuels (VHDs)** utilisés par les **machines virtuelles (VMs)** est facturé **séparément**. Même si la VM est **arrêtée/désallouée**, le stockage reste utilisé et continue donc **d'entraîner des coûts**.

There are two different payment options available for compute costs : **pay-as-you-go** and **Reserved VM Instances**.


> *French notes*: 

> La liste que nous venons d'examiner n'est pas exhaustive, mais elle représente les **principales décisions de conception** qui nécessitent une attention particulière avant tout déploiement.

Une fois ces décisions prises, nous pouvons commencer à réfléchir à la **création de notre machine virtuelle (VM)**.