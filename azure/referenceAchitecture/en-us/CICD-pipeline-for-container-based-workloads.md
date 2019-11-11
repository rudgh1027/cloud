# Describe this pattern
reference : https://docs.microsoft.com/en-us/azure/architecture/example-scenario/apps/devops-with-aks
<br></br>
<img src="https://docs.microsoft.com/en-us/azure/architecture/example-scenario/apps/media/architecture-devops-with-aks.png"></img>

## Feature
- In order to know details about this architecture, click above URL.

# Implement
## 1. Load teamplate file from predefined resource.
- Right click the Link: [Click Here](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmspnp%2Fsolution-architectures%2Fmaster%2Fapps%2Fdevops-with-aks%2Fazuredeploy.json), and open in the new tab.

- Login to Azure, then you can see <b>Custom deployment</b> in azure portal.

- Click azure cloud shell button on the top of the web page.

- After loading Azure Cloud Shell, Type <code>az ad sp create-for-rbac --name myDevOpsScenario</code>
<br></br> ※ If it says you don't have sufficiant privilige, ask your owner of subscription to give you <b>Owner</b> role or custom role that has <b>Microsoft.Authorization/roleAssignments/write</b>.
