# SerengetiDataLab

An E2E solution of the Data Resources on Azure using the Snapshot Serengeti dataset. This E2E solution focuses Azure Synapse Analytics,  Power Bi & the Azure Data Factory. 

## 🤔 Prerequisites
1. An active Azure Subscription. if you do not have one you can create a free Azure Subscription. 
2. Appropriate permissions within the Azure subscription that will allow for creating resources, assigning roles, registering providers and deleting resources.

    To proceed you need to deploy the following azure resources:
    * Microsoft.KeyVault
    * Microsoft.Synapse
    * Microsoft.ContainerRegistry
    * Microsoft.Storage
    * Microsoft.MachineLearningServices
    * Microsoft.Insights
    * Microsoft.OperationalInsights


    > :warning: In case any of these resources providers are not registered, follow the [steps from the documentation](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/resource-providers-and-types) to register them. 

3. Fork this repository to your GitHub account so that you can link it to the synapse workspace.


## 🚀 Lab Deployment
1. Right-click or `Ctrl + click` the button below to open the Azure Portal in a new tab and begin deployment.

    [![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FJcardif%2FSerengetiDataLab%2Fmain%2Fdeploy%2Fmain.json)

2. On the opened azure portal custom deployment page select the subscription from the drop-down, next click on the create new and provide a unique name to your resource group then select a [valid location](https://azure.microsoft.com/en-gb/explore/global-infrastructure/products-by-region/?products=machine-learning-service,synapse-analytics&regions=all) for the resources. 

    ![](/images/lab_deployment.png)

3. Provide the SQL login password which should contain at least `8 characters, 1 uppercase, 1 lowercase, 1 number and 1 special character` then click on the **Review + create** button.

4. Once the validation is done, click on the **Create** button to start the deployment.

5. The deployment should take approximately 10 minutes to complete. Once the deployment is completed, you can navigate to the resource group to check the deployed resources.
