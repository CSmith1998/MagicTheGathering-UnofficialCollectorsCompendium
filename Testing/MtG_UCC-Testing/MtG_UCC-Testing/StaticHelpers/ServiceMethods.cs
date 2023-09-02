using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Newtonsoft.Json;
using System.Net;
using System.Text;
using static MtG_UCC_Testing.ProjectConstants;

namespace MtG_UCC_Testing {
    public static class ServiceMethods {
        private static HttpClient _client;

        #region Authorization Encryption Methods
        public static String AuthEncryption(String username, String password) {
            return (Convert.ToBase64String(System.Text.ASCIIEncoding.Unicode.GetBytes(username + ":" + password)));
        }
        public static Dictionary<String, String> AuthDecryption(String AuthToken) {
            String unencryptedToken = System.Text.ASCIIEncoding.Unicode.GetString(Convert.FromBase64String(AuthToken.ToString().Substring("Basic ".Length).Trim()));
            int seperatorIndex = unencryptedToken.IndexOf(':');

            var username = unencryptedToken.Substring(0, seperatorIndex);
            var password = unencryptedToken.Substring(seperatorIndex + 1);

            Dictionary<String, String> UserDetails = new Dictionary<String, String>() {
                { "Username", username },
                { "Password", password }
            };

            return UserDetails;
        }
        #endregion

        public static Uri CompleteAddress(String Path) { 
            return new Uri(baseURL + "/" + Path);
        }

        public static String CompleteAuthToken(String auth) {
            return ("Basic " + auth);
        }

        #region Generate Response Methods
        public static async Task<HttpRequestMessage> BaseHttpRequest(HttpMethod method, Uri requestURI) {
            _client = new() { BaseAddress = new Uri(baseURL) };
            return (new HttpRequestMessage(method, requestURI));
        }
        public static async Task<HttpResponseMessage> GenerateResponse(HttpMethod method, Uri requestURI) {
            var request = await BaseHttpRequest(method, requestURI);
            return (await _client.SendAsync(request));
        }
        public static async Task<HttpResponseMessage> GenerateResponse(HttpMethod method, Uri requestURI, String authToken) {
            var request = await BaseHttpRequest(method, requestURI);
            request.Headers.Add("Authorization", authToken);

            return (await _client.SendAsync(request));
        }
        public static async Task<HttpResponseMessage> GenerateResponse(HttpMethod method, Uri requestURI, String authToken, String id) {
            var request = await BaseHttpRequest(method, requestURI);
            request.Headers.Add("Authorization", authToken);
            request.Headers.Add("AccountID", id);

            return (await _client.SendAsync(request));
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
                if (content is String) {
                    response.Content = new StringContent(content.ToString());
                } else {
                    var jsonContent = JsonConvert.SerializeObject(content);
                    response.Content = new StringContent(jsonContent, Encoding.Unicode, contentType);
                }
            }

            return response;
        }
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
        public static async Task<Card> RetrieveCardFromID(String CardID) {
            EstablishClient();
            Card RetrievedCard = null;

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
        #endregion
    }
}
