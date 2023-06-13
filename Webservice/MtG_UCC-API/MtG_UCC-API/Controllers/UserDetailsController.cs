using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using MtG_UCC_API.Models;
using Newtonsoft.Json;
using System.Net;

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
        public async Task<HttpResponseMessage> GetCompendium() {
            Dictionary<String, String> headers = GetHeaderValues(this.Request.Headers);
            List<Compendium> UserCompendium = new();

            String errorMessage = "";

            try { 
                if (await CheckAuthorization(GetAuthToken(headers))) {
                    var accountID = GetAccountID(headers);
                    var compendiumID = await GetCompendiumID(accountID);

                    if(compendiumID.IsNullOrEmpty()) {
                        errorMessage = "CompendiumID was not found for the user!";
                        return RequestResponse(HttpStatusCode.NotFound, errorMessage);
                    } else {
                        string username = await GetUsername(accountID);
                        UserCompendium = await GetUserCompendium(compendiumID);

                        return RequestResponse(HttpStatusCode.OK, JsonConvert.SerializeObject(UserCompendium), "application/json", $"{username}'s compendium was retrieved, containing {UserCompendium.Count} entries.");
                    }

                } else return RequestResponse(HttpStatusCode.Unauthorized, "You are not authorized to access this content!");
            } catch(Exception ex) {
                errorMessage = GenerateUnknownError(this.ControllerContext.RouteData, ex);
                return RequestResponse(HttpStatusCode.BadRequest, errorMessage);
            }
        }

        [HttpGet("/{CardID}")]  
        public async Task<HttpResponseMessage> GetCollection(String CardID) {
            Dictionary<String, String> headers = GetHeaderValues(this.Request.Headers);
            List<Collection> UserCollection = new();

            String errorMessage = "";

            try { 
                if (await CheckAuthorization(GetAuthToken(headers))) {
                    var accountID = GetAccountID(headers);
                    var compendiumID = await GetCompendiumID(accountID);

                    if(compendiumID.IsNullOrEmpty()) {
                        errorMessage = "CompendiumID was not found for the user!";
                        return RequestResponse(HttpStatusCode.NotFound, errorMessage);
                    } else {
                        string username = await GetUsername(accountID);
                        UserCollection = await GetUserCollection(compendiumID, CardID);

                        return RequestResponse(HttpStatusCode.OK, JsonConvert.SerializeObject(UserCollection), "application/json", $"{username}'s collection was retrieved, containing {UserCollection.Count} entries for '{CardID}'.");
                    }

                } else return RequestResponse(HttpStatusCode.Unauthorized, "You are not authorized to access this content!");
            } catch(Exception ex) {
                errorMessage = GenerateUnknownError(this.ControllerContext.RouteData, ex);
                return RequestResponse(HttpStatusCode.BadRequest, errorMessage);
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