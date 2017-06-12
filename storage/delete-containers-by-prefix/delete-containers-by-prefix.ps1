﻿# this script will show how to delete containers with a specific prefix 
# the prefix this will search for is "image". 
# before running this, you need to create a storage account, create some containers,
#    some having the same prefix so you can test this
# note: this retrieves all of the matching containers in one command 
#       if you are going to run this against a storage account with a lot of containers
#       (more than a couple hundred), use continuation tokens to retrieve
#       the list of containers. We will be adding a sample showing that scenario in the future.

# login to your Azure account
Login-AzureRmAccount

# these are for the storage account to be used
#   and the prefix for which to search
$resourceGroup = "containerdeletetestrg"
$location = "eastus"
$storageAccountName = "contosocontainerdeletetest"
$prefix = "image"

# get a reference to the storage account and the context
$storageAccount = Get-AzureRmStorageAccount `
  -ResourceGroupName $resourceGroup `
  -Name $storageAccountName
$ctx = $storageAccount.Context 

# list all containers in the storage account 
Write-Host "All containers"
Get-AzureStorageContainer -Context $ctx | select Name

# retrieve list of containers to delete
$listOfContainersToDelete = Get-AzureStorageContainer -Context $ctx -Prefix $prefix

# write list of containers to be deleted 
Write-Host "Containers to be deleted"
$listOfContainersToDelete | select Name

# delete the containers
Write-Host "Deleting containers"
$listOfContainersToDelete | ForEach-Object { Remove-AzureStorageContainer -Container $_.Name -Context $ctx }

# show list of containers not deleted 
Write-Host "All containers not deleted"
Get-AzureStorageContainer -Context $ctx | select Name
