# SerengetiDataLab

An E2E solution of the Data Resources on Azure using the Snapshot Serengeti dataset. This E2E solution focuses Azure Synapse Analytics,  Power Bi & the Azure Data Factory. 

## 🤔 Prerequisites
1. An active Azure Subscription. if you do not have one you can create a free Azure Subscription. 
2. Appropriate permissions within the Azure subscription that will allow for creating resources, assigning roles, registering providers and deleting resources.

## 🧪 Lab Deployment

To proceed you need to deploy the following azure resources:
* Microsoft.KeyVault
* Microsoft.Synapse
* Microsoft.ContainerRegistry
* Microsoft.Storage
* Microsoft.MachineLearningServices
* Microsoft.Insights
* Microsoft.OperationalInsights

> :warning: In case any opf these resources providers are not registered, follow the [steps from the documentation](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/resource-providers-and-types) to register them. 


Right-click or `Ctrl + click` the button below to open the Azure Portal in a new window.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FJcardif%2FSerengetiDataLab%2Fmain%2Fdeploy%2Fmain.json)
