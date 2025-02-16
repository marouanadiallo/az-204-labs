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
    You should avoid running a production workload on a single VM, as it wouldn’t be resilient in the face of planned or unplanned maintenance.

> *French notes :*

Différence entre **Availability Zone** et **Availability Set** dans Azure:

1. La protée de la redondance :
    - **Availability set** :
        - Opère **au sein d'un même datacenter** Azure.
        - Répartit les VMs sur des **domaines d'erreur (fault domains)** et **domaines de mise à jour (update domains)**.
        - **Domaine d'erreur** : Groupes de matériel partageant une source d'alimentation/switch réseau(ex: rack). En ca de panne matérielle, seuls les VMs du domaine affecté sont impactés.
        - **Domaine de mise à jour** : Groupe de VMs redémarrés séquentiellement lors de mises à jour Azure (évite les interruptions simultanées).
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
    - **Exclusivité** : Un VM ne peut appartenir **ni aux deux simultanément** ni à plusieurs Availability Sets.
    - **Disponibilité** : Les zones existent dans les régions Azure modernes (ex.: France centre, Europe Ouest), pas dans toutes.

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
| **Critère** | **VM Scale Sets** | **Availability Set** | **Availability Zone** |
| ------- | ------------- | ---------------- | ----------------- |
| **Objectif principal** |
|
