using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using static MtG_UCC_API.ServiceMethods;
using MtG_UCC_API.Models.Scryfall_Search;
using Microsoft.IdentityModel.Tokens;
using MtG_UCC_API.Models;
using MtG_UCC_API.Models.Scryfall_Card;

namespace MtG_UCC_API.Controllers {
    [ApiController]
    [Route("[controller]/[action]")]
    public class CollectionController : ControllerBase {
        private readonly ILogger<CollectionController> _logger;

        public CollectionController(ILogger<CollectionController> logger) {
            _logger = logger;
        }

        [HttpGet]
        public async Task<List<Condition>> GetAvailableGrades() {
            List<Condition> AvailableGrades = await GetConditions();

            return AvailableGrades;
        }

        [HttpPost("{Qty}")]
        public async Task<string> PostCardDetails(int Qty) {
            Dictionary<string, string> headers;
            Card? card = null;
            Collection? record = null;


            String Message = "";

            try {
                headers = GetHeaderValues(this.Request.Headers);

                if (await CheckAuthorization(GetAuthToken(headers))) {
                    var accountID = GetAccountID(headers);
                    var compendiumID = await GetCompendiumID(accountID);
                    

                    card = RetrieveCard(headers);
                    record = RetrieveCollection(headers);

                    if (card != null && record != null) {
                        Message = await CheckAndInsert(card, record, compendiumID);
                    } else Message = new($"A required parameter was missing!");

                    if(Message.Equals($"Successfully updated database!")) {
                        Message = new($"{Qty} {card.Name} added to {GetUsername(accountID)}'s collection!");
                    }
                } else Message = new($"Unauthorized access denied!");
            } catch (Exception ex) {
                Message = GenerateUnknownError(this.ControllerContext.RouteData, ex);
            }

            return Message;
        }

        [HttpPut]
        public async Task<string> EditCollectionDetails() { 
            Dictionary<string, string> headers;
            Collection? record = null;

            String Message = "";

            try {
                headers = GetHeaderValues(this.Request.Headers);

                if (await CheckAuthorization(GetAuthToken(headers))) {
                    var accountID = GetAccountID(headers);
                    record = RetrieveCollection(headers);

                    if(record != null) {
                        Message = await UpdateUserCollection(accountID, record);

                        if (Message.Equals($"Successfully deleted record!")) {
                            Message = new($"{GetUsername(accountID)}'s collection record was deleted successfully!");
                        }
                    } else Message = new($"CardID was not provided!");

                } else Message = new($"Unauthorized access denied!");
            } catch (Exception ex) {
                Message = GenerateUnknownError(this.ControllerContext.RouteData, ex);
            }

            return Message;
        }

        [HttpPut]
        public async Task<string> EditCollectionQuantity() {
            Dictionary<string, string> headers;
            Collection? record = null;

            String Message = "";

            try { 
                headers = GetHeaderValues(this.Request.Headers);

                if (await CheckAuthorization(GetAuthToken(headers))) {
                    var accountID = GetAccountID(headers);
                    record = RetrieveCollection(headers);

                    Message = await UpdateCollectionQuantity(accountID, record);

                    if (Message.Equals($"Successfully updated database!")) {
                        Message = new($"{GetUsername(accountID)}'s collection was updated successfully!");
                    }

                } else Message = new($"Unauthorized access denied!");
            } catch(Exception ex) {
                Message = GenerateUnknownError(this.ControllerContext.RouteData, ex);
            }

            return Message;
        }

        [HttpDelete]
        public async Task<string> DeleteUserCollection() { 
            Dictionary<string, string> headers;
            Collection? record = null;

            String Message = "";

            try { 
                headers = GetHeaderValues(this.Request.Headers);

                if (await CheckAuthorization(GetAuthToken(headers))) {
                    var accountID = GetAccountID(headers);
                    record = RetrieveCollection(headers);

                    if(record != null) {
                        Message = await DeleteRecord(record);
                    } else Message = new($"User's collection record was not provided!");

                    if (Message.Equals($"Successfully updated database!")) {
                        Message = new($"{GetUsername(accountID)}'s collection was updated successfully!");
                    }

                } else Message = new($"Unauthorized access denied!");
            } catch(Exception ex) {
                Message = GenerateUnknownError(this.ControllerContext.RouteData, ex);
            }

            return Message;
        }
    }
}
