using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using MtG_UCC_API.Models;

using static MtG_UCC_API.ServiceMethods;

namespace MtG_UCC_API.Controllers {
    [ApiController]
    [Route("[controller]/[action]")]
    public class UserDetailsController : ControllerBase {
        private readonly ILogger<UserDetailsController> _logger;

        public UserDetailsController(ILogger<UserDetailsController> logger) {
            _logger = logger;
        }

        [HttpGet]
        public async Task<List<Compendium>> GetCompendium() {
            Dictionary<String, String> headers = GetHeaderValues(this.Request.Headers);
            List<Compendium> UserCompendium = new();

            String errorMessage = "";

            try { 
                if (await CheckAuthorization(GetAuthToken(headers))) {
                    var accountID = GetAccountID(headers);
                    var compendiumID = await GetCompendiumID(accountID);

                    if(compendiumID.IsNullOrEmpty()) {
                        errorMessage = "CompendiumID was not found for the user!";
                        UserCompendium.Add(new Compendium("ERROR", "NotFound", "", errorMessage, 404));

                        return UserCompendium;
                        //return RequestResponse(HttpStatusCode.NotFound, errorMessage);
                    } else {
                        string username = await GetUsername(accountID);
                        UserCompendium = await GetUserCompendium(compendiumID);

                        return UserCompendium;
                        //return RequestResponse(HttpStatusCode.OK, JsonConvert.SerializeObject(UserCompendium), "application/json", $"{username}'s compendium was retrieved, containing {UserCompendium.Count} entries.");
                    }

                } else {
                    UserCompendium.Add(new Compendium("ERROR", "Unauthorized", "", "You are not authorized to access this content!", 401));

                    return UserCompendium;
                    //return RequestResponse(HttpStatusCode.Unauthorized, "You are not authorized to access this content!");
                }
            } catch(Exception ex) {
                errorMessage = GenerateUnknownError(this.ControllerContext.RouteData, ex);
                UserCompendium.Add(new Compendium("ERROR", "Unknown", "", errorMessage, 400));

                return UserCompendium;
                //return RequestResponse(HttpStatusCode.BadRequest, ex.ToString());
            }
        }

        [HttpGet("{CardName}")]  
        public async Task<List<Collection>> GetCollection(String CardName = null) {
            Dictionary<String, String> headers = GetHeaderValues(this.Request.Headers);
            List<Collection> UserCollection = new();

            String errorMessage = "";

            try { 
                if (await CheckAuthorization(GetAuthToken(headers))) {
                    var accountID = GetAccountID(headers);
                    var compendiumID = await GetCompendiumID(accountID);

                    if(compendiumID.IsNullOrEmpty()) {
                        errorMessage = "CompendiumID was not found for the user!";
                        UserCollection.Add(new Collection("404", "NotFound", "", "https://pandemoniumbooks.com/cdn/shop/products/mtg_placeholder_f91b371f-6043-4a82-8b81-dc2855e39a65_large.png?v=1684507268", "", "", new Condition(), errorMessage, 404));

                        return UserCollection;
                        //return RequestResponse(HttpStatusCode.NotFound, errorMessage);
                    } else {
                        if(CardName == "None") {
                            UserCollection = await GetUserCollection(compendiumID, null);
                        } else UserCollection = await GetUserCollection(compendiumID, CardName);

                        return UserCollection;
                        //return RequestResponse(HttpStatusCode.OK, JsonConvert.SerializeObject(UserCollection), "application/json", $"{username}'s collection was retrieved, containing {UserCollection.Count} entries for '{CardID}'.");
                    }

                } else {
                    UserCollection.Add(new Collection("401", "Unauthorized", "", "https://pandemoniumbooks.com/cdn/shop/products/mtg_placeholder_f91b371f-6043-4a82-8b81-dc2855e39a65_large.png?v=1684507268", "", "", new Condition(), "You are not authorized to access this content!", 401));

                    return UserCollection;
                    //return RequestResponse(HttpStatusCode.Unauthorized, "You are not authorized to access this content!");
                }
            } catch(Exception ex) {
                errorMessage = GenerateUnknownError(this.ControllerContext.RouteData, ex);
                UserCollection.Add(new Collection("400", "Unknown", "", "https://pandemoniumbooks.com/cdn/shop/products/mtg_placeholder_f91b371f-6043-4a82-8b81-dc2855e39a65_large.png?v=1684507268", "", "", new Condition(), $"CardName: {CardName}\nTrace: {errorMessage}", 400));

                return UserCollection;
                //return RequestResponse(HttpStatusCode.BadRequest, errorMessage);
            }
        }

        #region Access Events
        [HttpPost]
        public async Task<HttpResponseMessage> Login() {
            return await NewAccessEvent(AccessType.LOGIN, this.Request.Headers, this.ControllerContext.RouteData);
        }
        [HttpPost]
        public async Task<HttpResponseMessage> Logout() {
            return await NewAccessEvent(AccessType.LOGOUT, this.Request.Headers, this.ControllerContext.RouteData);
        }
        [HttpPost]
        public async Task<HttpResponseMessage> Register() {
            return await NewAccessEvent(AccessType.REGISTRATION, this.Request.Headers, this.ControllerContext.RouteData);
        }
        [HttpPost]
        public async Task<HttpResponseMessage> ConfirmEmail() {
            return await NewAccessEvent(AccessType.EMAIL_CONFIRMATION, this.Request.Headers, this.ControllerContext.RouteData);
        }
        [HttpPost]
        public async Task<HttpResponseMessage> Delete() {
            return await NewAccessEvent(AccessType.ACCOUNT_DELETION, this.Request.Headers, this.ControllerContext.RouteData);
        }
        #endregion
    }
}