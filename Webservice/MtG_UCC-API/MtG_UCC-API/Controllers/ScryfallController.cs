using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System.Net;
using static MtG_UCC_API.ServiceMethods;
using MtG_UCC_API.Models.Scryfall_Search;
using Microsoft.IdentityModel.Tokens;
using MtG_UCC_API.Models.Scryfall_Card;

namespace MtG_UCC_API.Controllers {
    [Route("[controller]/[action]")]
    [ApiController]
    public class ScryfallController : ControllerBase {
        [HttpGet("{CardID}")]
        public async Task<Card> GetCardDetails(String CardID) {
            Card? RetrievedCard = new();
            String errorMessage = "";

            try {
                RetrievedCard = await RetrieveCardFromID(CardID);

                if(RetrievedCard == null) {
                    errorMessage = $"Card with ID '{CardID}' was not found!";
                    RetrievedCard.Object = $"Error 404: {errorMessage}";
                } else {
                    
                }
            } catch(Exception ex) {
                errorMessage = GenerateUnknownError(this.ControllerContext.RouteData, ex);
                RetrievedCard.Object = $"Error 400: {errorMessage}";
            }

            return RetrievedCard;
        }

        [HttpGet]
        public async Task<Root> GetCardDetails() {
            Root RetrievedCards = new();
            String errorMessage = "";

            try { 
                Dictionary<String, String> headers = GetHeaderValues(this.Request.Headers);
                SearchParameters? parameters = RetrieveParameters(headers);
            
                if(parameters != null) {
                    RetrievedCards = await RetrieveCardsFromQuery(parameters);

                    if(RetrievedCards == null) {
                        errorMessage = "Your query produced no matching cards.";
                        RetrievedCards.Object = $"Error 404: {errorMessage}";
                    }
                } else {
                    errorMessage = "Expected JSON \"Search Parameters\" were not found!";
                    RetrievedCards.Object = $"Error 424: {errorMessage}";
                }
            } catch(Exception ex) {
                errorMessage = GenerateUnknownError(this.ControllerContext.RouteData, ex);
                RetrievedCards.Object = $"Error 400: {errorMessage}";
            }

            return RetrievedCards;
        }

        [HttpGet]
        public HttpResponseMessage FormatQuery() {
            String errorMessage = "";

            try {
                Dictionary<String, String> headers = GetHeaderValues(this.Request.Headers);
                var json = headers.GetValueOrDefault("SearchParams");

                if (!json.IsNullOrEmpty()) {
                    SearchParameters parameters = JsonConvert.DeserializeObject<SearchParameters>(json);

                    if(parameters != null) { return RequestResponse(HttpStatusCode.OK, parameters.ToString()); }
                        else { return RequestResponse(HttpStatusCode.BadRequest, "Failed to deserialize json."); }

                } else {
                    errorMessage = "Expected JSON \"Search Parameters\" were not found!";
                    return RequestResponse(HttpStatusCode.FailedDependency, errorMessage); 
                }
                
            } catch(Exception ex) {
                errorMessage = GenerateUnknownError(this.ControllerContext.RouteData, ex);
                return RequestResponse(HttpStatusCode.BadRequest, errorMessage);
            } 
        }
    }
}
