using System.Net;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
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
        public HttpResponseData Run([HttpTrigger(AuthorizationLevel.Anonymous, "get")] HttpRequestData req)
        {
            _logger.LogInformation("C# HTTP trigger function processed a request.");

            var sourceContainer  = "https://lilablobssc.blob.core.windows.net/snapshotserengeti-v-2-0";

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

            var destinationContainerName="zippedmetadatafiles";
            

            return response;
        }
    }
}
