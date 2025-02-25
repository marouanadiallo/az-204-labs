# Deploy an Azure Container Registry

As with any service, you need **the subscription**, a **resource group**, and 
**the region** to which you want to deploy.

- Repository name constraints :

Valid char [a-zA-Z0-9]* and with a minimum of **5** characters and a maximum of **50** characters.

## Azure CLI 

*Create resource groupe*\
```az group create --name az204ContainerEcosys --location westeurope```

*Create ACR*\
``` az acr create --resource-group az204ContainerEcosys  --name alphamacr --sku Basic ```


*Log in to registry*\
``` az acr login --name alphamacr```

**Push image to registry** :

*Create an alias to image*\
``` docker tag <image:tag> <alphamacr.azurecr.io/<image:tag> ```

*Push the image to repository*\
``` docker push alphamacr.azurecr.io/<image:tag> ```

*List the repositories*\
``` az acr repository list --name alphamacr -o tsv ```

*Show tags within repository*\
``` az acr repository show-tags --name alphamacr --repository webapp -o tsv ```

*Pull and run a container locally from the image in ACR*\
``` docker run -it --rm -p 8080:80 alphamacr.azurecr.io/webapp:v1 ```

## Building and Pushing to ACR Using ACR Tasks

*Run the ACR build quick task*\
``` az acr build --image <imagename:tag> --registry alphamacr . ```

*Confirm the new v2 tag is in your repository*\
``` az acr repository show-tags --name alphamacr --repository webapp -o tsv ```

*Run a container using the latest image from a cloud-based agent*\
``` az acr run --registry alphamacr --cmd '$Registry/webapp:v2' /dev/null ```\
Using **$Registry** just states that the command should run **from the registry**. A **context is required** for this command, but using **/dev/null** allows you to set a null context, as it’s not required in this case. *--cmd* : commands to execute. This also supports additional docker run parameters.

## Create ACI

*Use following command*\
Enable the **built-in admin user account** on ACR is required when we want to run container instances using ACI directly from images stored in ACR.\
``` az container create -g <resource-g> -n <aci-name> --image <registryname.azurecr.io/<img:tag> --cpu <number> --memory <number> --registry-login-server <rgstry.azurecr.io> --registry-username <usrname> --registry-password <pwd> --ports <number> --dns-name-label <unique dns label> --os-type <Linux | Windows> ```
