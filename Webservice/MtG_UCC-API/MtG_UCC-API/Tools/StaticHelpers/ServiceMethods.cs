using Microsoft.Data.SqlClient;
using Microsoft.IdentityModel.Tokens;
using MtG_UCC_API.Models;
using MtG_UCC_API.Models.Scryfall_Search;
using Newtonsoft.Json;
using System.Net;
using System.Net.NetworkInformation;
using System.Text;

using static MtG_UCC_API.SQLMethods;

namespace MtG_UCC_API {
    public static class ServiceMethods {
        #region Global Variables
        private static HttpClient _client;

        public enum AccessType { LOGIN, LOGOUT, REGISTRATION, EMAIL_CONFIRMATION, ACCOUNT_DELETION }
        #endregion

        #region Authorization Encryption Methods
        public static String AuthEncryption(String username, String password) {
            var auth = (Convert.ToBase64String(System.Text.ASCIIEncoding.UTF8.GetBytes(username + ":" + password)));
            return ("Basic " + auth);
        }
        public static Dictionary<String, String> AuthDecryption(String AuthToken) {
            String unencryptedToken = System.Text.ASCIIEncoding.UTF8.GetString(Convert.FromBase64String(AuthToken.Substring("Basic ".Length).Trim()));
            int seperatorIndex = unencryptedToken.IndexOf(':');

            var username = unencryptedToken.Substring(0, seperatorIndex);
            var password = unencryptedToken.Substring(seperatorIndex + 1);

            Dictionary<String, String> UserDetails = new Dictionary<String, String>() {
                { "Username", username },
                { "Password", password }
            };

            return UserDetails;
        }
        public async static Task<bool> CheckAuthorization(String AuthToken) {
            if(AuthToken == null) { return false; }

            var UserDetails = AuthDecryption(AuthToken);

            var username = UserDetails.GetValueOrDefault("Username");
            var password = UserDetails.GetValueOrDefault("Password");

            var connection = await EstablishSQLConnection($"SELECT [Admin].[UserValidation]('{username}', '{password}')");
            var result = 0;

            if (connection == 1) {
                result = (int)await cmd.ExecuteScalarAsync();
                EndSQLConnection();
            }

            return (result == 1);
        }
        public static String GetAuthToken(Dictionary<String, String> headers) {
            return headers.GetValueOrDefault("Authorization");
        }
        #endregion

        #region Retrieve User Details
        public static String GetAccountID(Dictionary<String, String> headers) {
            return headers.GetValueOrDefault("AccountID");
        }

        public async static Task<String?> GetCompendiumID(String AccountID) {
            var connection = await EstablishSQLConnection($"SELECT [User].[GetCompendiumID]('{AccountID}')");
            String ID = null;

            if(connection == 1) {
                ID = (String)await cmd.ExecuteScalarAsync();
                EndSQLConnection();
            }

            return ID;
        }
        public async static Task<String?> GetUsername(String AccountID) {
            var connection = await EstablishSQLConnection($"SELECT [User].[GetUsername]('{AccountID}')");
            String Username = null;

            if(connection == 1) {
                Username = (String)await cmd.ExecuteScalarAsync();
                EndSQLConnection();
            }

            return Username;
        }
        #endregion

        #region Input Access Details
        public async static Task<int> GenerateNewAccessEvent(String AccountID, AccessType Type, String IP) {
            var connection = await EstablishSQLConnection($"EXECUTE [Admin].[NewAccess]('{AccountID}'. '{Type.ToString()}', '{IP}')");
            int RowsEffected = 0;

            if(connection == 1) {
                RowsEffected = await cmd.ExecuteNonQueryAsync();
                EndSQLConnection();
            }

            return RowsEffected;
        }
        public async static Task<HttpResponseMessage> NewAccessEvent(AccessType ActionType, IHeaderDictionary _headers, RouteData route) {
            Dictionary<String, String> headers = GetHeaderValues(_headers);
            var accountID = GetAccountID(headers);
            var IP = headers.GetValueOrDefault("IP");

            String errorMessage = "";

            try { 
                if(accountID.IsNullOrEmpty()) {
                    errorMessage = "AccountID was not found for the user!";
                    return RequestResponse(HttpStatusCode.NotFound, errorMessage);
                } else {
                    string username = await GetUsername(accountID);
                    int Result = await GenerateNewAccessEvent(accountID, ActionType, IP);

                    if (Result == 0) {
                        errorMessage = "Registration of access event to database failed!";
                        return RequestResponse(HttpStatusCode.NotModified, errorMessage);
                    } else {
                        return RequestResponse(HttpStatusCode.Created, $"New {ActionType} event for {username} was was successfully registered to the database.");
                    }
                }
            } catch(Exception ex) {
                errorMessage = GenerateUnknownError(route, ex);
                return RequestResponse(HttpStatusCode.BadRequest, errorMessage);
            }
        }
        #endregion

        #region Retrieve Lists From Database
        public async static Task<List<Compendium>> GetUserCompendium(String CompendiumID) {
            List<Compendium> UserCompendium = new();

            var connection = await EstablishSQLConnection($"SELECT * FROM [User].[Compendium] WHERE ID = '{CompendiumID}'");
            
            if(connection == 1) { 
                SqlDataReader reader = await cmd.ExecuteReaderAsync();

                while(await reader.ReadAsync()) {
                    UserCompendium.Add(new Compendium() {
                        ID = reader.GetString(reader.GetOrdinal("ID")),
                        CardName = reader.GetString(reader.GetOrdinal("CardName")),
                        ManaCost = reader.GetString(reader.GetOrdinal("ManaCost")),
                        ColorIdentity = reader.GetString(reader.GetOrdinal("ColorIdentity")),
                        TotalQuantity = reader.GetInt32(reader.GetOrdinal("TotalQty"))
                    });
                }
            }

            return UserCompendium;
        }

        public static async Task<List<String>> RetrieveCardNames(List<String> IDs) {
            List<String> CardNames = new();

            foreach(String CardID in IDs) { 
                var connection = await EstablishSQLConnection($"SELECT [MtG].[GetCardName]('{CardID}')");
                String CardName = null;

                if(connection == 1) {
                    CardName = (String)await cmd.ExecuteScalarAsync();
                    EndSQLConnection();
                }

                CardNames.Add(CardName);
            }

            return CardNames;
        }

        public async static Task<List<Collection>> GetUserCollection(String CompendiumID, String CardName = null) {
            List<Collection> UserCollection = new();

            int connection;

            if (CardName == null || CardName == "None" || CardName == "") {
                connection = await EstablishSQLConnection($"SELECT * FROM [User].[GetFullCollection]('{CompendiumID}')");
            } else {
                connection = await EstablishSQLConnection($"SELECT * FROM [User].[GetCardCollection]('{CompendiumID}', '{CardName}')");
            }

            if (connection == 1) { 
                SqlDataReader reader = await cmd.ExecuteReaderAsync();

                while(await reader.ReadAsync()) {
                    UserCollection.Add(new Collection() {
                        CompendiumID = reader.GetString(reader.GetOrdinal("CompendiumID")),
                        CardID = reader.GetString(reader.GetOrdinal("CardID")),
                        CardName = reader.GetString(reader.GetOrdinal("CardName")),
                        CardFace = reader.GetString(reader.GetOrdinal("CardFace")),
                        SetName = reader.GetString(reader.GetOrdinal("SetName")),
                        SetIcon = reader.GetString(reader.GetOrdinal("SetIcon")),
                        CardCondition = new Condition() { 
                            ID = reader.GetString(reader.GetOrdinal("Condition")),
                            Type = reader.GetString(reader.GetOrdinal("Type")),
                            Name = reader.GetString(reader.GetOrdinal("Name")),
                            Description = reader.GetString(reader.GetOrdinal("Description"))
                        },
                        StorageLocation = reader.GetString(reader.GetOrdinal("StorageLocation")),
                        Quantity = reader.GetInt32(reader.GetOrdinal("Quantity"))
                    });
                }
            }

            return UserCollection;
        }
        #endregion

        #region Http Extension Methods
        public static Dictionary<String, String> GetHeaderValues(IHeaderDictionary dictionary) { 
            Dictionary<String, String> temp = new Dictionary<String, String>();
            foreach(var header in dictionary) {
                temp.Add(header.Key, header.Value);
            }

            return temp;
        }
        public static HttpResponseMessage RequestResponse(HttpStatusCode statusCode, object content = null, String contentType = "text/plain", String message = null) {
            var response = new HttpResponseMessage(statusCode);

            if (!String.IsNullOrEmpty(message)) {
                response.Headers.Add("Message", message);
            }

            if (content != null) {
                var jsonContent = JsonConvert.SerializeObject(content);
                response.Content = new StringContent(jsonContent, Encoding.Unicode, contentType);
                response.Content.Headers.Add("json", jsonContent);
            }

            return response;
        }

        //public static HttpResponseMessage RequestResponse(HttpStatusCode statusCode, List<object> content = null, String contentType = "text/plain", String message = null) {
        //    var response = new HttpResponseMessage(statusCode);

        //    if (!String.IsNullOrEmpty(message)) {
        //        response.Headers.Add("Message", message);
        //    }

        //    var jsonContent = JsonConvert.SerializeObject(content);
        //    response.Content = new StringContent(jsonContent, Encoding.Unicode, "application/json");
        //    response.Content.Headers.Add("json", jsonContent);

        //    return response;
        //}

        public static String GenerateUnknownError(RouteData route, Exception ex = null) {
            var actionName = route.Values["action"].ToString();
            var controllerName = route.Values["controller"].ToString();

            StringBuilder errorbuilder = new();

            errorbuilder.Append("An unexpected error has occured!");
            errorbuilder.Append($"\nAction: {actionName}, Controller: {controllerName}");
            errorbuilder.Append($"\nTimestamp: {DateTime.Now.ToString()}");
            if(ex != null) { errorbuilder.Append($"\nStackTrace: {ex.StackTrace}"); }

            return errorbuilder.ToString();
        }
        #endregion

        #region API Call Methods
        public static void EstablishClient(Uri? URL = null) {
            _client = new();

            if(URL == null) {
                _client.BaseAddress = new Uri("https://api.scryfall.com/cards/");
            } else _client.BaseAddress = URL;
        }
        public static void CloseClient() {
            if(_client != null) { _client.Dispose(); }
        }

        #endregion

        #region Scryfall Methods
        public static async Task<Card?> RetrieveCardFromID(String CardID) {
            EstablishClient();
            Card? RetrievedCard = null;

            var response = _client.GetAsync(CardID).Result;
            if(response.IsSuccessStatusCode) {
                String json = await response.Content.ReadAsStringAsync();
                RetrievedCard = JsonConvert.DeserializeObject<Card>(json);

                if(RetrievedCard != null) {
                    RetrievedCard.DetermineIdentity();
                }
            }

            CloseClient();
            return RetrievedCard;
        }

        public static async Task<List<Card>?> RetrieveCardsFromQuery(SearchParameters parameters) {
            List<Card>? RetrievedCards = new();

            if (parameters != null) {
                EstablishClient();

                var response = _client.GetAsync($"search{parameters.ToString()}").Result;
                if(response.IsSuccessStatusCode) {
                    RetrievedCards = JsonConvert.DeserializeObject<List<Card>>(await response.Content.ReadAsStringAsync());

                    if(RetrievedCards != null) { 
                        foreach(Card item in RetrievedCards) {
                            item.DetermineIdentity();
                        }
                    }
                }

                CloseClient();
            }

            return RetrievedCards;
        }

        public static SearchParameters? RetrieveParameters(Dictionary<String, String> headers) {
            SearchParameters? RetrievedParameters = null;

            var json = headers.GetValueOrDefault("SearchParams");

            if(!json.IsNullOrEmpty()) {
                RetrievedParameters = JsonConvert.DeserializeObject<SearchParameters>(json);
            }

            return RetrievedParameters;
        }
        #endregion
    }
}