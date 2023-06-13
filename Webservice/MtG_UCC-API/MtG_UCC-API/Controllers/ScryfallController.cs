using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Routing;
using Newtonsoft.Json;
using System.Net;
using static MtG_UCC_API.ServiceMethods;
using MtG_UCC_API.Models.Scryfall_Search;
using Microsoft.IdentityModel.Tokens;

namespace MtG_UCC_API.Controllers {
    [Route("[controller]/[action]")]
    [ApiController]
    public class ScryfallController : ControllerBase {
        [HttpGet("/{CardID}")]
        public async Task<HttpResponseMessage> GetCardDetails(String CardID) {
            String errorMessage = "";

            try {
                Card? RetrievedCard = await RetrieveCardFromID(CardID);

                if(RetrievedCard != null) {
                    return RequestResponse(HttpStatusCode.OK, JsonConvert.SerializeObject(RetrievedCard), "application/json", $"Card '{RetrievedCard.Name}' was successfully retrieved at {DateTime.Now.ToLocalTime}.");
                } else {
                    errorMessage = $"Card with ID '{CardID}' was not found!";
                    return RequestResponse(HttpStatusCode.NotFound, errorMessage);
                }
            } catch(Exception ex) {
                errorMessage = GenerateUnknownError(this.ControllerContext.RouteData, ex);
                return RequestResponse(HttpStatusCode.BadRequest, errorMessage);
            }
        }

        [HttpGet]
        public async Task<HttpResponseMessage> GetCardDetails() {
            String errorMessage = "";

            try { 
                Dictionary<String, String> headers = GetHeaderValues(this.Request.Headers);
                SearchParameters? parameters = RetrieveParameters(headers);
            
                if(parameters != null) {
                    List<Card>? RetrievedCards = await RetrieveCardsFromQuery(parameters);

                    if(RetrievedCards != null) {
                        return RequestResponse(HttpStatusCode.OK, JsonConvert.SerializeObject(RetrievedCards), "application/json", $"Your query produced {RetrievedCards.Count} cards successfully.");
                    } else {
                        errorMessage = "Your query produced no matching cards.";
                        return RequestResponse(HttpStatusCode.NotFound, errorMessage);
                    }
                } else {
                    errorMessage = "Expected JSON \"Search Parameters\" were not found!";
                    return RequestResponse(HttpStatusCode.FailedDependency, errorMessage);
                }
            } catch(Exception ex) {
                errorMessage = GenerateUnknownError(this.ControllerContext.RouteData, ex);
                return RequestResponse(HttpStatusCode.BadRequest, errorMessage);
            }
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
