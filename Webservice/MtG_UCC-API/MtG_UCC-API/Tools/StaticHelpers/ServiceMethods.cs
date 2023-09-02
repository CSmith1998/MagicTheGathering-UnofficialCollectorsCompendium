using Microsoft.Data.SqlClient;
using Microsoft.IdentityModel.Tokens;
using MtG_UCC_API.Models;
using MtG_UCC_API.Models.Database;
using MtG_UCC_API.Models.Scryfall_Card;
using MtG_UCC_API.Models.Scryfall_Search;
using Newtonsoft.Json;
using System.Data;
using System.Diagnostics;
using System.Net;
using System.Net.NetworkInformation;
using System.Text;

using static MtG_UCC_API.SQLMethods;
using static MtG_UCC_API.ProjectConstants;
using static System.Collections.Specialized.BitVector32;
using Microsoft.AspNetCore.Hosting.Server;

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
        public static string Base64Decode(string base64EncodedData) {
            var base64EncodedBytes = System.Convert.FromBase64String(base64EncodedData);
            return System.Text.Encoding.UTF8.GetString(base64EncodedBytes);
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
        public async static Task<bool> CheckAdminAuthorization(String Authtoken, String AccountID) { 
            if(Authtoken == null) { return false; }

            var UserDetails = AuthDecryption(Authtoken);

            var username = UserDetails.GetValueOrDefault("Username");
            var password = UserDetails.GetValueOrDefault("Password");

            var connection = await EstablishSQLConnection($"SELECT [Admin].[AdminValidation]('{username}', '{password}', '{AccountID}')");
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
        public static String GetUserAccountID(Dictionary<String, String> headers) {
            return headers.GetValueOrDefault("UserAccountID");
        }
        public static String GetRoleID(Dictionary<String, String> headers) {
            return headers.GetValueOrDefault("RoleID");
        }

        public static Collection? RetrieveCollection(Dictionary<string, string> headers) {
            Collection? record = null;

            var json = headers.GetValueOrDefault("Collection");

            if(!json.IsNullOrEmpty()) {
                Console.WriteLine($"\n\n\nDecoded Json: {Base64Decode(json)}"); Debug.WriteLine($"\n\n\nDecoded Json: {Base64Decode(json)}");
                record = JsonConvert.DeserializeObject<Collection>(Base64Decode(json));
            }

            return record;
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

            if (connection == 1) { 
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

            EndSQLConnection();

            return UserCompendium;
        }
        public async static Task<List<CardStatistic>> GetTop25() {
            List<CardStatistic> Stats = new();

            var connection = await EstablishSQLConnection($"SELECT * FROM [Admin].[Top25Cards]()");

            if(connection == 1) {
                SqlDataReader reader = await cmd.ExecuteReaderAsync();

                while(await reader.ReadAsync()) {
                    Stats.Add(new CardStatistic() {
                        CardID = reader.GetString(reader.GetOrdinal("CardID")),
                        Count = reader.GetInt32(reader.GetOrdinal("Count")),
                        Name = reader.GetString(reader.GetOrdinal("Name")),
                        PNG = reader.GetString(reader.GetOrdinal("PNG")),
                        SetName = reader.GetString(reader.GetOrdinal("SetName")),
                        SetIcon = reader.GetString(reader.GetOrdinal("SetIcon")),
                        ManaCost = reader.GetString(reader.GetOrdinal("ManaCost")),
                        ColorIdentity = reader.GetString(reader.GetOrdinal("ColorIdentity"))
                    });
                }
            }

            EndSQLConnection();

            return Stats;
        }
        public async static Task<string> DeleteUserFromDatabase(String UserID) {
            var connection = await EstablishSQLConnection($"EXECUTE [Admin].[DeleteUser] '{UserID}");

            if(connection == 1) {
                await cmd.ExecuteNonQueryAsync();
            }

            return $"Successfully deleted record!";
        }

        public async static Task<List<UsersWithRoles>> RetrieveUsersWithRoles() {
            List<UsersWithRoles> list = new();

            var connection = await EstablishSQLConnection($"SELECT * FROM [Admin].[GetUsersWithRoles]()");

            if(connection == 1) {
                SqlDataReader reader = await cmd.ExecuteReaderAsync();

                while(await reader.ReadAsync()) {
                    list.Add(new UsersWithRoles() {
                        UserId = reader.GetString(reader.GetOrdinal("UserId")),
                        UserName = reader.GetString(reader.GetOrdinal("UserName")),
                        RoleId = reader.GetString(reader.GetOrdinal("RoleId")),
                        RoleName = reader.GetString(reader.GetOrdinal("RoleName")),
                    });
                }
            }

            return list;
        }
        
        public async static Task<List<Condition>> GetConditions() {
            List<Condition> states = new();

            var connection = await EstablishSQLConnection($"SELECT * FROM [MtG].[AvailableGrades]");

            if(connection == 1) {
                SqlDataReader reader = await cmd.ExecuteReaderAsync();

                while(await reader.ReadAsync()) { 
                    states.Add(new Condition() { 
                        ID = reader.GetString(reader.GetOrdinal("ID")),
                        Type = reader.GetString(reader.GetOrdinal("Type")),
                        Name = reader.GetString(reader.GetOrdinal("Name")),
                        Description = reader.GetString(reader.GetOrdinal("Description"))
                    });
                }
            }

            EndSQLConnection();

            return states;
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

            EndSQLConnection();

            return UserCollection;
        }
        #endregion

        #region Modify Database
        public async static Task<string> CheckAndInsert(Card card, Collection record, string compendiumID) {
            int connection;
            string response = "";

            try { 
                connection = await EstablishSQLConnection($"SELECT [MtG].[CheckCardExists]('{card.Id}')");
                
                if(connection == 1) {
                    //Debug.WriteLine($"Connection succeeded : CardID = {card.Id}"); Console.WriteLine($"Connection succeeded : CardID = {card.Id}");
                    int result = (int)await cmd.ExecuteScalarAsync();
                    //Debug.WriteLine($"result = {result}"); Console.WriteLine($"result = {result}");

                    if (result != 1) {
                        //Debug.WriteLine($"Card Does Not Exist"); Console.WriteLine($"Card Does Not Exist");
                        card.DetermineIdentity();

                        string SetIcon = await RetrieveSetIconFromID(card.SetId);

                        string png = "";
                        if(card.ImageUris == null) {
                            png = card.CardFaces[0].ImageUris.Png;
                        } else png = card.ImageUris.Png;

                        cmd = new SqlCommand($"EXECUTE [MtG].[NewCard] '{card.Id}', '{card.Name}', '{png}', '{card.SetName}', '{SetIcon}', '{card.ManaCost}', '{card.Identity}'", conn);

                        await cmd.ExecuteNonQueryAsync();
                    }

                    string condition, location;
                    condition = record.CardCondition.ID;
                    location = record.StorageLocation;

                    if (condition == null || condition == "") { condition = "UO-UKN"; }
                    if (location == null || condition == "") { location = "Undefined"; }

                    cmd = new SqlCommand($"EXECUTE [User].[InsertIntoCollection] '{compendiumID}', '{card.Id}', '{condition}', '{location}', {record.Quantity}", conn);

                    await cmd.ExecuteNonQueryAsync();
                    response = new($"Successfully updated database!");
                } else response = new($"SQL Connection failed");

            } catch (Exception ex) {
                //Debug.WriteLine($"\n\n\nException details: {ex.StackTrace} --- {ex.InnerException.StackTrace}");
                //Console.WriteLine($"\n\n\nException details: {ex.StackTrace} --- {ex.InnerException.StackTrace}");
                return (response = new($"An unknown exception occurred! {ex.StackTrace}"));
            } finally {
                EndSQLConnection();
            }

            return response;
        }
        public static async Task<string> UpdateUserCollection(string AccountID, Collection record) {
            int connection;
            string response = "";

            try {
                string condition, location, cardID;
                condition = record.CardCondition.ID;
                location = record.StorageLocation;


                if (condition == null || condition == "") { condition = "UO-UKN"; }
                if (location == null || condition == "") { location = "Undefined"; }

                connection = await EstablishSQLConnection($"EXECUTE [User].[UpdateCollection] '{AccountID}', '{record.CardID}', '{condition}', '{location}', {record.Quantity}");

                if(connection == 1) {
                    await cmd.ExecuteNonQueryAsync();
                    response = new($"Successfully updated database!");
                } else response = new($"SQL Connection failed");

            } catch(Exception ex) {
                return (response = new($"An unknown exception occurred! {ex.StackTrace}"));
            } finally {
                EndSQLConnection();
            }

            return response;
        }
        public static async Task<string> UpdateCollectionQuantity(string AccountID, Collection record) {
            int connection;
            string response = "";

            try {
                connection = await EstablishSQLConnection($"EXECUTE [MtG].[UpdateCardQuantity] '{AccountID}', '{record.CardID}', '{record.CardCondition.ID}', '{record.StorageLocation}', {record.Quantity}");

                if(connection == 1) {
                    await cmd.ExecuteNonQueryAsync();
                    response = new($"Successfully updated database!");
                } else response = new($"SQL Connection failed");

            } catch(Exception ex) {
                return (response = new($"An unknown exception occurred! {ex.StackTrace}"));
            } finally {
                EndSQLConnection();
            }

            return response;
        }
        public static async Task<string> DeleteRecord(Collection record) {
            int connection;
            string response = "";

            try {
                connection = await EstablishSQLConnection($"DELETE FROM [User].[Collection] WHERE CompendiumID = '{record.CompendiumID}' AND CardID = '{record.CardID}' AND Condition = '{record.CardCondition.ID}' AND StorageLocation = '{record.StorageLocation}'");

                if(connection == 1) {
                    await cmd.ExecuteNonQueryAsync();
                    response = new($"Successfully deleted record!");
                } else response = new($"SQL Connection failed");

            } catch(Exception ex) {
                return (response = new($"An unknown exception occurred! {ex.StackTrace}"));
            } finally {
                EndSQLConnection();
            }

            return response;
        }
        public static async Task<string> ChangeUserRole(string AccountID, string RoleID)
        {
            string response = "";

            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString)) // Replace yourConnectionString with the actual connection string to your SQL Server database
                {
                    await connection.OpenAsync();

                    using (SqlCommand cmd = new SqlCommand("[Admin].[ChangeUserRole]", connection))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;

                        cmd.Parameters.Add("@UserId", SqlDbType.NVarChar).Value = AccountID;
                        cmd.Parameters.Add("@RoleId", SqlDbType.NVarChar).Value = RoleID;

                        await cmd.ExecuteNonQueryAsync();

                        response = "Successfully updated record!";
                    }
                }
            }
            catch (Exception ex)
            {
                response = $"An unknown exception occurred! {ex.StackTrace}";
                Console.WriteLine($"EXCEPTION : {response}");
                Debug.WriteLine($"EXCEPTION : {response}");
            }

            return response;
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
            Card? RetrievedCard = null;

            EstablishClient();

            Console.WriteLine($"\n\n\nCard ID: {CardID}\n\n\n"); Debug.WriteLine($"\n\n\nCard ID: {CardID}\n\n\n");

            var response = _client.GetAsync(CardID).Result;
            if(response.IsSuccessStatusCode) {
                String json = await response.Content.ReadAsStringAsync();
                Console.WriteLine($"\n\n\nJson: {json}\n\n\n"); Debug.WriteLine($"\n\n\nJson: {json}\n\n\n");
                RetrievedCard = JsonConvert.DeserializeObject<Card>(json);

                if(RetrievedCard != null) {
                    RetrievedCard.DetermineIdentity();
                }
            }

            CloseClient();
            return RetrievedCard;
        }

        public static async Task<Root> RetrieveCardsFromQuery(SearchParameters parameters) {
            Root ApiReply = new();

            if (parameters != null)
            {
                EstablishClient();

                var response = _client.GetAsync($"search{parameters.ToString()}").Result;
                if (response.IsSuccessStatusCode)
                {
                    var json = await response.Content.ReadAsStringAsync();
                    try
                    {
                        var settings = new JsonSerializerSettings
                        {
                            Error = (sender, args) =>
                            {
                                // Log or inspect the error here
                                Console.WriteLine(args.ErrorContext.Error);
                            }
                        };

                        ApiReply = JsonConvert.DeserializeObject<Root>(json, settings);
                    }
                    catch (Exception ex)
                    {
                        // Log or handle the exception here
                        Console.WriteLine(ex.Message);
                    }
                }

                CloseClient();
            }

            return ApiReply;
        }

        public static async Task<string> RetrieveSetIconFromID(String SetID) {
            Set retrievedSet = new();
            string result = "";

            EstablishClient(new Uri($"https://api.scryfall.com/sets/"));

            var response = _client.GetAsync($"{SetID}").Result;

            if(response.IsSuccessStatusCode ) { 
                result = await response.Content.ReadAsStringAsync();
                retrievedSet = JsonConvert.DeserializeObject<Set>(result);
            }
            CloseClient();

            return retrievedSet.IconSvgUri;
        }
        public static SearchParameters? RetrieveParameters(Dictionary<String, String> headers) {
            SearchParameters? RetrievedParameters = null;

            var json = headers.GetValueOrDefault("SearchParams");

            if(!json.IsNullOrEmpty()) {
                RetrievedParameters = JsonConvert.DeserializeObject<SearchParameters>(json);
            }

            return RetrievedParameters;
        }
        public static Card? RetrieveCard(Dictionary<string, string> headers) {
            Card? card = null;

            var json = headers.GetValueOrDefault("Card");

            if(!json.IsNullOrEmpty()) {
                //Console.WriteLine($"\n\n\nDecoded Json: {Base64Decode(json)}"); Debug.WriteLine($"\n\n\nDecoded Json: {Base64Decode(json)}");
                card = JsonConvert.DeserializeObject<Card>(Base64Decode(json));
            }

            return card;
        }
        #endregion
    }
}