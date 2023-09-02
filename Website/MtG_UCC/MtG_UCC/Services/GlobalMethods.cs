using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using MtG_UCC.Data;
using MtG_UCC.Models;
using MtG_UCC.Models.Database;
using MtG_UCC.Models.Microsoft_Identity;
using MtG_UCC.Models.Scryfall_Card;
using MtG_UCC.Models.Scryfall_Search;
using Newtonsoft.Json;
using System.Diagnostics;
using System.Net;
using System.Net.NetworkInformation;
using System.Security.Claims;
using System.Security.Policy;
using System.Text;
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
            public static async Task<String?> CreateAuthToken(UserManager<IdentityUser> context, ClaimsPrincipal user) { 
                var CurrentUser = await context.FindByNameAsync(user.Identity.Name);

                if(CurrentUser != null) { 
                    String UserName = CurrentUser.UserName;
                    String Password = CurrentUser.PasswordHash;
                    //return AuthEncryption(UserName, Password);
                    if (UserName != null && Password != null) {

                        return AuthEncryption(UserName, Password);
                    }
                }

                return null;
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
            public static async Task<String?> CreateAccountToken(UserManager<IdentityUser> context, ClaimsPrincipal user) { 

                var CurrentUser = await context.FindByNameAsync(user.Identity.Name);

                if(CurrentUser != null) { 
                    String AccountID = CurrentUser.Id;

                    return AccountID;
                }

                return null;
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
            public static async Task<List<Condition>> RetrieveAvailableGrades() {
                List<Condition> RetrievedList = new();

                EstablishClient();

                var response = await _client.GetAsync($"Collection/GetAvailableGrades");

                if(response.IsSuccessStatusCode) {
                    String json = await response.Content.ReadAsStringAsync();
                    RetrievedList = JsonConvert.DeserializeObject<List<Condition>>(json);
                }

                CloseClient();

                return RetrievedList;
            }
        public static async Task<List<CardStat>> RetrieveTop25(UserManager<IdentityUser> context, ClaimsPrincipal user) {
            List<CardStat> stats = new();

            EstablishClient();
            var authAttempt = await EstablishAuthentication(context, user);

            if(authAttempt.ContainsKey(HttpStatusCode.OK)) {
                var accountAttempt = await EstablishAccountID(context, user);

                if(accountAttempt.ContainsKey(HttpStatusCode.OK)) {
                    var response = await _client.GetAsync("Admin/UserCardStatistics");

                    var json = await response.Content.ReadAsStringAsync();
                    stats = JsonConvert.DeserializeObject<List<CardStat>>(json);
                }
            }

            CloseClient();

            return stats;
        }


        public static async Task<List<Card>> RetrieveCardsFromSearch(SearchParameters parameters) {
            List<Card> RetrievedCards = new();
            Root reply = new();

            EstablishClient(new Uri("https://api.scryfall.com/cards/"));

            var response = await _client.GetAsync($"search{parameters.ToString()}");
            //Debug.WriteLine($"Original Search Parameters: {parameters.ToString()}"); Console.WriteLine($"Original Search Parameters: {parameters.ToString()}");

            if (response.IsSuccessStatusCode) {
                var json = await response.Content.ReadAsStringAsync();
                //Debug.WriteLine($"Original json: {json}"); Console.WriteLine($"Original json: {json}");

                JsonSerializerSettings settings = new() {
                    MissingMemberHandling = MissingMemberHandling.Ignore,

                };
                reply = JsonConvert.DeserializeObject<Root>(json, settings);

                RetrievedCards = reply.Data;

                foreach (Card item in RetrievedCards) {
                    item.DetermineIdentity();
                }
            } //else {
                //Debug.WriteLine("Not Success Code"); Console.WriteLine("Not Success Code");
            //}

            CloseClient();

            return RetrievedCards;
        }
        public static async Task<Card> RetrieveCardFromID(String CardID) {
            Card RetrievedCard = new();
            Root reply = new();

            EstablishClient();

            var response = await _client.GetAsync($"Scryfall/GetCardDetails/{CardID}");
            //Debug.WriteLine($"Original Search Parameters: {parameters.ToString()}"); Console.WriteLine($"Original Search Parameters: {parameters.ToString()}");

            if (response.IsSuccessStatusCode) {
                var json = await response.Content.ReadAsStringAsync();
                //Debug.WriteLine($"Original json: {json}"); Console.WriteLine($"Original json: {json}");

                JsonSerializerSettings settings = new() {
                    MissingMemberHandling = MissingMemberHandling.Ignore,

                };
                RetrievedCard = JsonConvert.DeserializeObject<Card>(json, settings);

                RetrievedCard.DetermineIdentity();
            } //else {
                //Debug.WriteLine("Not Success Code"); Console.WriteLine("Not Success Code");
            //}

            CloseClient();

            return RetrievedCard;
        }

        public static async Task<bool> CommitCollectionToDatabase(Collection record, String json) {
            var url = $"Collection/PostCardDetails/{record.Quantity}";
            var request = new HttpRequestMessage(HttpMethod.Post, url);

            // Add any required headers to the request, if needed
            var recordJson = JsonConvert.SerializeObject(record);

            //Console.WriteLine($"\n\nCard Json: {json}\nRecord Json: {recordJson}\n\n"); Debug.WriteLine($"\n\nCard Json: {json}\nRecord Json: {recordJson}\n\n");
            
            request.Headers.Add("Card", Base64Encode(json));
            request.Headers.Add("Collection", Base64Encode(recordJson));

            var response = await _client.SendAsync(request);

            if(response.IsSuccessStatusCode) {
                //Console.WriteLine($"\n\n\nAttempt message: {await response.Content.ReadAsStringAsync()}\n\n\n");
                return true;
            } else {
                //Console.WriteLine(response.Content.ToString());
                return false;
            }
        }
        public static async Task<List<UsersWithRoles>> GetAllUsersAndRoles(UserManager<IdentityUser> context, ClaimsPrincipal user) {
            List<UsersWithRoles> list = new();

            EstablishClient();
            await EstablishAuthentication(context, user);
            await EstablishAccountID(context, user);

            var response = await _client.GetAsync("Admin/GetAllUsers");

            var json = await response.Content.ReadAsStringAsync();
            list = JsonConvert.DeserializeObject<List<UsersWithRoles>>(json);

            return list;
        }
        public static async void DeleteUser(UserManager<IdentityUser> context, ClaimsPrincipal user, String UserID) {
            List<UsersWithRoles> list = new();

            EstablishClient();
            await EstablishAuthentication(context, user);
            await EstablishAccountID(context, user);

            await _client.DeleteAsync($"Admin/DeleteUser/{UserID}");
        }
        public static async Task<bool> UpdateUserRole(UserManager<IdentityUser> context, ClaimsPrincipal user, String UserID, String RoleID) {
            List<UsersWithRoles> list = new();

            var url = $"Admin/UpdateUserRole";
            var request = new HttpRequestMessage(HttpMethod.Put, url);
            request.Headers.Add("Authorization", await CreateAuthToken(context, user));
            request.Headers.Add("AccountID", await CreateAccountToken(context, user));
            request.Headers.Add("UserAccountID", UserID);
            request.Headers.Add("RoleID", RoleID);

            var response = await _client.SendAsync(request);

            if(response.IsSuccessStatusCode) {
                return true;
            } else {
                return false;
            }
            
            return false;
        }
        public static async Task<bool> CommitChangesToCollection(Collection record) {
            var url = $"Collection/EditCollectionDetails";
            var request = new HttpRequestMessage(HttpMethod.Put, url);

            var recordJson = JsonConvert.SerializeObject(record);
            request.Headers.Add("Collection", Base64Encode(recordJson));

            var response = await _client.SendAsync(request);

            if(response.IsSuccessStatusCode) {
                return true;
            } else {
                return false;
            }
        }

        public static async Task<List<Collection>> RetrieveUserCollection(String CardName = null) { 
                List<Collection> RetrievedList = new();

                if(CardName == null || CardName == "") CardName = "None";
                var response = await _client.GetAsync($"UserDetails/GetCollection/{CardName}");
                
                if(response.IsSuccessStatusCode) { 
                    String json = await response.Content.ReadAsStringAsync();
                    //Debug.WriteLine(json); Console.WriteLine(json);
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

            var pascalCase = invalidCharsRgx.Replace(whiteSpace.Replace(original, "_"), string.Empty)
                .Split(new char[] { '_' }, StringSplitOptions.RemoveEmptyEntries)
                .Select(w => startsWithLowerCaseChar.Replace(w, m => m.Value.ToUpper()))
                .Select(w => firstCharFollowedByUpperCasesOnly.Replace(w, m => m.Value.ToLower()))
                .Select(w => lowerCaseNextToNumber.Replace(w, m => m.Value.ToUpper()))
                .Select(w => upperCaseInside.Replace(w, m => m.Value.ToLower()));

            return string.Concat(pascalCase);
        }
        public static string Base64Encode(string plainText) {
            var plainTextBytes = System.Text.Encoding.UTF8.GetBytes(plainText);
            return System.Convert.ToBase64String(plainTextBytes);
        }
    }
}
