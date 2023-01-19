using System.Net;
using Azure.Storage.Blobs;
using Azure.Storage.Files.DataLake;
using Azure.Storage.Sas;
using Lab.Functions.Services;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace Lab.Functions
{
    public class CopyMetadataFiles
    {
        private readonly ILogger _logger;

        public CopyMetadataFiles(ILoggerFactory loggerFactory)
        {
            _logger = loggerFactory.CreateLogger<CopyMetadataFiles>();
        }

        [Function("CopyMetadataFiles")]
        public async Task<HttpResponseData> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get")] HttpRequestData req)
        {
            _logger.LogInformation("C# HTTP trigger function processed a request.");

            var sourceConnectionString="BlobEndpoint=https://lilablobssc.blob.core.windows.net;";
            var sourceContainerName="snapshotserengeti-v-2-0";

            // s01 to s011
            var metadataFiles=new string[]
            {
                "SnapshotSerengetiS01.json.zip",
                "SnapshotSerengetiS02.json.zip",
                "SnapshotSerengetiS03.json.zip",
                "SnapshotSerengetiS04.json.zip",
                "SnapshotSerengetiS05.json.zip",
                "SnapshotSerengetiS06.json.zip",
                "SnapshotSerengetiS07.json.zip",
                "SnapshotSerengetiS08.json.zip",
                "SnapshotSerengetiS09.json.zip",
                "SnapshotSerengetiS10.json.zip",
                "SnapshotSerengetiS11.json.zip",
                "SnapshotSerengetiSplits_v0.json",
                "SnapshotSerengetiBboxes_20190903.json.zip",
                "SnapshotSerengetiSplits_v0.json"
            };


            var storageService=new AzureStorageService();
            var config = GetAppSettings();

            var accountName= config["AzureStorage:DataLakeStorageAccountName"];
            var accountKey=config["AzureStorage:DataLakeStorageAccountKey"];

            var adlsClient = storageService.GetDataLakeServiceClient(accountName, accountKey);

            var fileSystemName="default";
            var directoryName="metadata";

            var fileSystemClient = await storageService.CreateFileSystem(adlsClient, fileSystemName);
            var directoryClient = await storageService.CreateDirectory(adlsClient, fileSystemName, directoryName);

            var sourceContainerClient=new BlobContainerClient(sourceConnectionString, sourceContainerName);

            foreach (var metadataFile in metadataFiles)
            {
                var sourceBlobClient = sourceContainerClient.GetBlobClient(metadataFile);
                // if file exists continue
                if (directoryClient.GetFileClient(metadataFile).Exists())
                {
                    _logger.LogInformation("file exists");
                    continue;
                }

                var fileClient = directoryClient.GetFileClient(metadataFile);

                var url=fileClient.GenerateSasUri(DataLakeSasPermissions.All, DateTimeOffset.UtcNow.AddMinutes(5)).ToString();


                var blobUrl=url.Replace("dfs.core.windows.net", "blob.core.windows.net");

                var destBlobClient = new BlobClient(new Uri(blobUrl));

                var ops= await destBlobClient.StartCopyFromUriAsync(sourceBlobClient.Uri);
                // wait for the copy to complete
                await ops.WaitForCompletionAsync();

                _logger.LogInformation($"Copied {metadataFile} to {destBlobClient.Uri}");
            }

            var response = req.CreateResponse(HttpStatusCode.OK);
            return response;
        }

        private static dynamic GetAppSettings()
        {
            var config = new ConfigurationBuilder()
                .SetBasePath(Directory.GetCurrentDirectory())
                .AddJsonFile("local.settings.json", optional: true, reloadOnChange: true)
                .AddEnvironmentVariables()
                .Build();

            return config;
        }
    }
}
