# Architecture Azure pour la gestion des emails d'un restaurant

## 📩 1. Envoi des e-mails (Notifications, Confirmations, etc.)
- **Service utilisé** : Azure Communication Services (ACS) Email.
- **But** : Envoyer des e-mails de notification (ex : confirmation de commande).
- **Authentification** : Azure Identity Manager.

### 📌 Étapes :
1. Configurer Azure Communication Services (ACS) avec un domaine d'envoi.
2. Utiliser ACS Email SDK dans Spring Boot pour envoyer des e-mails.
3. Authentifier l’application avec Managed Identity.

---

## 📥 2. Réception des e-mails (Support client, demandes, etc.)
- **Service utilisé** : Microsoft Graph API + Webhook.
- **But** : Lire les e-mails envoyés par les clients (ex: support@monresto.com).
- **Authentification** : Azure Identity Manager.

### 📌 Étapes :
1. Créer un compte e-mail Outlook / Exchange Online.
2. Enregistrer une application dans Azure AD avec les permissions nécessaires (`Mail.Read`).
3. Utiliser Microsoft Graph API pour s’abonner aux nouveaux e-mails entrants.
4. Créer un Webhook Spring Boot pour recevoir les notifications.
5. Stocker ou traiter les e-mails reçus.

---

## 🔒 3. Sécurisation avec Azure Identity Manager
- **Service utilisé** : Managed Identity (Azure AD Identity Manager).
- **But** : Éviter de stocker des secrets API et gérer automatiquement les tokens d’accès.

### 📌 Étapes :
1. Activer une Managed Identity sur Azure App Service.
2. Donner les permissions nécessaires (`Mail.Read`, `Azure Communication Services`).
3. Utiliser Azure Identity SDK pour récupérer les tokens dynamiquement.

---

## 🏁 Résumé final de l'architecture
✅ Envoi d’e-mails avec **Azure Communication Services (ACS)**.  
✅ Réception des e-mails clients avec **Microsoft Graph API + Webhook Spring Boot**.  
✅ Authentification sécurisée avec **Azure Identity Manager (Managed Identity)**.  

---

## 💰 Coût estimé

| **Service** | **Coût mensuel estimé** |
|------------|----------------------|
| Azure Communication Services (ACS) | ~$1-5 (dépend du volume d’e-mails envoyés) |
| Microsoft Graph API + Webhook | ~$0 si hébergé en Free Tier |
| Azure Managed Identity | $0 (inclus avec App Service) |

📌 **Avantage principal** : Plus **sécurisé**, **moins coûteux** qu’Azure Logic Apps, et **temps réel** 🚀.
