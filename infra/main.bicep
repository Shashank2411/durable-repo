param functionAppName string = 'durablefunc7287'
param location string = 'Central India'

var storageName = toLower(substring(replace('${functionAppName}${uniqueString(resourceGroup().id)}', '-', ''), 0, 24))

resource storage 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

resource plan 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: '${functionAppName}-plan'
  location: location
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
}

resource functionApp 'Microsoft.Web/sites@2023-01-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp'
  properties: {
    serverFarmId: plan.id
    siteConfig: {
      siteConfig: {
        appSettings: [
            {
            name: 'AzureWebJobsStorage'
            value: 'DefaultEndpointsProtocol=https;AccountName=${storage.name};AccountKey=${listKeys(storage.id, \'2023-01-01\').keys[0].value};EndpointSuffix=core.windows.net'
            }
            {
            name: 'FUNCTIONS_WORKER_RUNTIME'
            value: 'node'
            }
            {
            name: 'FUNCTIONS_EXTENSION_VERSION'
            value: '~4'
            }
        ]
}
    }
  }
}