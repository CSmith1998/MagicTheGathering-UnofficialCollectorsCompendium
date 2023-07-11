using Microsoft.AspNetCore.Identity;
using MtG_UCC.Models;
using Newtonsoft.Json;
using System.Net;
using System.Security.Claims;
using System.Text.RegularExpressions;

namespace MtG_UCC.Services {
    public static class GlobalMethods {
        #region Global Variables
            private static HttpClient _client;
            private static readonly string _baseURL;
            public enum AccessType { LOGIN, LOGOUT, REGISTRATION, EMAIL_CONFIRMATION, ACCOUNT_DELETION }
        #endregion

        #region API Call Methods
            public static void EstablishClient(Uri ? Base = null, Uri? Route = null) {
                var address = new Uri("http://localhost:5045/");

                _client = new();

                if(Base != null) {
                    address = Base;
                }

                if(Route != null) { 
                    address = new Uri(Base.ToString() + Route.ToString());
                }

                _client.BaseAddress = address;
            }
            public static void CloseClient() {
                if(_client != null) { _client.Dispose(); }
            }
            public static void CreateHeader(String Key, String Value) { 
                if(_client != null) { 
                    _client.DefaultRequestHeaders.Add(Key, Value);
                }
            }
            public static async Task<Dictionary<HttpStatusCode, String>> EstablishAuthentication(UserManager<IdentityUser> context, ClaimsPrincipal user) { 
                Dictionary<HttpStatusCode, String> response = new();

                var CurrentUser = await context.FindByNameAsync(user.Identity.Name);

                if(CurrentUser != null) { 
                    String UserName = CurrentUser.UserName;
                    String Password = CurrentUser.PasswordHash;
                    //return AuthEncryption(UserName, Password);
                    if (UserName != null && Password != null) {

                        CreateHeader("Authorization", AuthEncryption(UserName, Password));

                        response.Add(HttpStatusCode.OK, $"Authorization details for {UserName} was successfully placed in request header.");
                    } else response.Add(HttpStatusCode.BadRequest, $"Username or Password was not successfully obtained!");
                } else response.Add(HttpStatusCode.NotFound, $"A valid user was not found!");

                return response;
            }
            public static async Task<Dictionary<HttpStatusCode, String>> EstablishAccountID(UserManager<IdentityUser> context, ClaimsPrincipal user) { 
                Dictionary<HttpStatusCode, String> response = new();

                var CurrentUser = await context.FindByNameAsync(user.Identity.Name);

                if(CurrentUser != null) { 
                    String AccountID = CurrentUser.Id;

                    if (AccountID != null) {
                        CreateHeader("AccountID", AccountID);

                        response.Add(HttpStatusCode.OK, $"Account details for {CurrentUser.UserName} was successfully placed in request header.");
                    } else response.Add(HttpStatusCode.BadRequest, $"Account details were not successfully obtained!");
                } else response.Add(HttpStatusCode.NotFound, $"A valid account was not found!");

                return response;
            }

            public static async Task<List<Compendium>> RetrieveUserCompendium() { 
                List<Compendium> RetrievedList = new();
                var response = await _client.GetAsync($"UserDetails/GetCompendium");
                
                if(response.IsSuccessStatusCode) { 
                    String json = await response.Content.ReadAsStringAsync();
                    RetrievedList = JsonConvert.DeserializeObject<List<Compendium>>(json);
                }

                CloseClient();

                return RetrievedList;
            }   

            public static async Task<List<Collection>> RetrieveUserCollection(String CardName = null) { 
                List<Collection> RetrievedList = new();

                if(CardName == null || CardName == "") CardName = "None";
                var response = await _client.GetAsync($"UserDetails/GetCollection/{CardName}");
                
                if(response.IsSuccessStatusCode) { 
                    String json = await response.Content.ReadAsStringAsync();
                    RetrievedList = JsonConvert.DeserializeObject<List<Collection>>(json);
                }

                CloseClient();

                return RetrievedList;
            }
        #endregion

        public static String AuthEncryption(String username, String password) {
            var auth = (Convert.ToBase64String(System.Text.ASCIIEncoding.UTF8.GetBytes(username + ":" + password)));
            return ("Basic " + auth);
        }
        public static string ToPascalCase(string original) {
            Regex invalidCharsRgx = new Regex("[^_a-zA-Z0-9]");
            Regex whiteSpace = new Regex(@"(?<=\s)");
            Regex startsWithLowerCaseChar = new Regex("^[a-z]");
            Regex firstCharFollowedByUpperCasesOnly = new Regex("(?<=[A-Z])[A-Z0-9]+$");
            Regex lowerCaseNextToNumber = new Regex("(?<=[0-9])[a-z]");
            Regex upperCaseInside = new Regex("(?<=[A-Z])[A-Z]+?((?=[A-Z][a-z])|(?=[0-9]))");

            // replace white spaces with undescore, then replace all invalid chars with empty string
            var pascalCase = invalidCharsRgx.Replace(whiteSpace.Replace(original, "_"), string.Empty)
                // split by underscores
                .Split(new char[] { '_' }, StringSplitOptions.RemoveEmptyEntries)
                // set first letter to uppercase
                .Select(w => startsWithLowerCaseChar.Replace(w, m => m.Value.ToUpper()))
                // replace second and all following upper case letters to lower if there is no next lower (ABC -> Abc)
                .Select(w => firstCharFollowedByUpperCasesOnly.Replace(w, m => m.Value.ToLower()))
                // set upper case the first lower case following a number (Ab9cd -> Ab9Cd)
                .Select(w => lowerCaseNextToNumber.Replace(w, m => m.Value.ToUpper()))
                // lower second and next upper case letters except the last if it follows by any lower (ABcDEf -> AbcDef)
                .Select(w => upperCaseInside.Replace(w, m => m.Value.ToLower()));

            return string.Concat(pascalCase);
        }
    }
}
