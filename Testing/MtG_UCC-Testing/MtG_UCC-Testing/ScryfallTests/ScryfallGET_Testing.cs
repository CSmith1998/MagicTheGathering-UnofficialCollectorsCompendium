using Newtonsoft.Json;
using System.Net;
using Xunit;
using static MtG_UCC_Testing.ServiceMethods;

namespace MtG_UCC_Testing.ScryfallTests {
    public class ScryfallGET_Testing {
        [Theory,
            InlineData("ae155ee2-008f-4dc6-82bf-476be7baa224", "Archangel Avacyn // Avacyn, the Purifier", "Boros")]
        public async static void TestGetCardFromID(String CardID, String Name, String Identity) { 
            Card RetrievedCard = await RetrieveCardFromID(CardID);

            String errorMessage = "";

            if(RetrievedCard != null) {
                var temp = RequestResponse(HttpStatusCode.OK, JsonConvert.SerializeObject(RetrievedCard), "application/json", $"Card '{RetrievedCard.Name}' was successfully retrieved at {DateTime.Now.ToLocalTime}.");
            } else {
                errorMessage = $"Card with ID '{CardID}' was not found!";
                var temp = RequestResponse(HttpStatusCode.NotFound, errorMessage);
            }

            bool actual = (CardID == RetrievedCard.Id && Name == RetrievedCard.Name && Identity == RetrievedCard.Identity);

            Assert.True(actual, JsonConvert.SerializeObject(RetrievedCard));
        }
    }
}
