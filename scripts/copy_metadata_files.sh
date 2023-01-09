# Set the storage account name and resource group name
storage_account_name="serengetidatalab"
resource_group_name="SerengetiDataLab"

# Set the container name and blobs to copy
container_name="metadata"
blobs_to_copy=("SnapshotSerengetiS01.json.zip" "SnapshotSerengetiS02.json.zip" "SnapshotSerengetiS03.json.zip")

# Set the subscription
az account set --subscription "a1a27566-3e3c-42d7-a372-692095cd8521"

# Create a storage account
az storage account create --name $storage_account_name --resource-group $resource_group_name --sku Standard_LRS

# Get the storage account key
storage_account_key=$(az storage account keys list --account-name $storage_account_name --resource-group $resource_group_name --query "[0].value" -o tsv)

# Create a container
az storage container create --name $container_name --account-name $storage_account_name --account-key $storage_account_key

# Loop through the blobs to copy
for blob in "${blobs_to_copy[@]}"
do
  # Set the source URL for the blob
  source_url="https://lilablobssc.blob.core.windows.net/snapshotserengeti-v-2-0/$blob"

  # Start the copy process
  az storage blob copy start --source-uri $source_url --destination-blob $blob --destination-container $container_name --account-name $storage_account_name --account-key $storage_account_key
done

# Unset the storage account key
unset storage_account_key
