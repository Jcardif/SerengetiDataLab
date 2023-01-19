using Azure.Storage;
using Azure.Storage.Files.DataLake;

namespace Lab.Functions.Services
{
    public class AzureStorageService
    {
        public  DataLakeServiceClient GetDataLakeServiceClient(string accountName, string accountKey)
        {
            StorageSharedKeyCredential sharedKeyCredential =
                new StorageSharedKeyCredential(accountName, accountKey);

            string dfsUri = "https://" + accountName + ".dfs.core.windows.net";

            var dataLakeServiceClient = new DataLakeServiceClient
                (new Uri(dfsUri), sharedKeyCredential);
            
            return dataLakeServiceClient;
        }

        public async Task<DataLakeFileSystemClient> CreateFileSystem(DataLakeServiceClient serviceClient, string fileSystemName)
        {
            if(!serviceClient.GetFileSystemClient(fileSystemName).Exists())
                return await serviceClient.CreateFileSystemAsync(fileSystemName);
            else
                return serviceClient.GetFileSystemClient(fileSystemName);
        }

        public async Task<DataLakeDirectoryClient> CreateDirectory(DataLakeServiceClient serviceClient, string fileSystemName, string directoryName)
        {
            DataLakeFileSystemClient fileSystemClient = serviceClient.GetFileSystemClient(fileSystemName);

            return await fileSystemClient.CreateDirectoryAsync(directoryName);
        }
    }
}