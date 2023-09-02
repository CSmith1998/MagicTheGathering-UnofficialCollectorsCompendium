using static System.Net.Http.HttpClient;
using Xunit;
using System;
using System.Net;
using Microsoft.Data.SqlClient;
using System.Text;

namespace MtG_UCC_Testing.WebServiceTests {
    public class GET_Testing {
        private static readonly String connectionString = "Server=tcp:enterprise-applications.database.windows.net,1433;Initial Catalog=MtG-UCC-DataRepository;Persist Security Info=False;User ID=SmithCaine;Password=EnterpriseApplications2023;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;";

        public static string baseURL = "http://localhost:";
        public readonly HttpClient _client = new() { BaseAddress = new Uri(baseURL) };

        [Theory,
            InlineData("Username", "Password", "UserID", HttpStatusCode.OK),
            InlineData("Username", "Password", "UserID", HttpStatusCode.NotFound)]
        public async void TestGetUserCompendium(String username, String password, String id, HttpStatusCode expectedCode) {
            var AuthToken = ServiceMethods.CompleteAuthToken(ServiceMethods.AuthEncryption(username, password));
            var RequestURI = ServiceMethods.CompleteAddress(baseURL, "UserDetails/GetCompendium");

            var request = new HttpRequestMessage(HttpMethod.Get, RequestURI);
            request.Headers.Add("Authorization", AuthToken);
            request.Headers.Add("AccountID", id);

            var response = await _client.SendAsync(request);

            var isTrue = response.StatusCode == expectedCode;
            Assert.True(isTrue, response.StatusCode.ToString());
        }

        [Theory,
            InlineData("Username", "Password", "UserID", "CardID", HttpStatusCode.OK),
            InlineData("Username", "Password", "UserID", "CardID", HttpStatusCode.NotFound)]
        public async void TestGetUserCollection(String username, String password, String id, String cardID, HttpStatusCode expectedCode) {
            var AuthToken = ServiceMethods.CompleteAuthToken(ServiceMethods.AuthEncryption(username, password));
            var RequestURI = ServiceMethods.CompleteAddress(baseURL, $"UserDetails/GetCollection/{cardID}");

            var request = new HttpRequestMessage(HttpMethod.Get, RequestURI);
            request.Headers.Add("Authorization", AuthToken);
            request.Headers.Add("AccountID", id);

            var response = await _client.SendAsync(request);

            var isTrue = response.StatusCode == expectedCode;
            Assert.True(isTrue, response.StatusCode.ToString());
        }

        [Theory,
            InlineData("CardID", HttpStatusCode.OK),
            InlineData("CardID", HttpStatusCode.NotFound)]
        public async void TestGetCardDetails(String cardID, HttpStatusCode expectedCode) {
            var RequestURI = ServiceMethods.CompleteAddress(baseURL, $"UserDetails/GetCardDetails/{cardID}");

            var request = new HttpRequestMessage(HttpMethod.Get, RequestURI);

            var response = await _client.SendAsync(request);

            var isTrue = response.StatusCode == expectedCode;
            Assert.True(isTrue, response.StatusCode.ToString());
        }

        [Theory,
            InlineData("CardID", "ExpectedJSON")]
        public async void TestReceivedCardDetails(String cardID, String expectedJSON) {
            var RequestURI = ServiceMethods.CompleteAddress(baseURL, $"UserDetails/GetCardDetails/{cardID}");

            var request = new HttpRequestMessage(HttpMethod.Get, RequestURI);

            var response = await _client.SendAsync(request);
            var message = await response.Content.ReadAsStringAsync();

            var isTrue = message.Equals(expectedJSON);
            Assert.True(isTrue, String.Format("Status Code: {0}\nExpected: {1}\tActual: {2}", response.StatusCode.ToString(), expectedJSON, message));
        }

        [Theory,
            InlineData("f97c771c-95f5-492d-a0b8-d25db8300678")]
        public async static void GetCompendiumID(String AccountID) {
            String ID = "";

            using(SqlConnection conn = new SqlConnection(connectionString))
            using(SqlCommand cmd = new SqlCommand($"SELECT [User].[GetCompendiumID]('{AccountID}')", conn)) {
                conn.Open();
                ID = (String)await cmd.ExecuteScalarAsync();
                conn.Close();
            }

            Assert.Equal("UCf97c-0678_0", ID);
        }

        public static String EncodeAuth(String username, String password) {
            String AuthToken = ("Basic " + (Convert.ToBase64String(Encoding.ASCII.GetBytes(username + ":" + password))));
            return AuthToken;
        }

        [Theory,
            InlineData("cls56@students.ptcollege.edu", "AQAAAAEAACcQAAAAEDpQoO+Zb1j4ApshfVSZQiEBpGFLtYYM6TZcAZPA95rwaNns4ZVUC9JwekDF0DDnOw==")]
        public async static void Authorization(String baseUser, String basePass) {
            var AuthToken = EncodeAuth(baseUser, basePass);

            String unencryptedToken = System.Text.ASCIIEncoding.UTF8.GetString(Convert.FromBase64String(AuthToken.ToString().Substring("Basic ".Length).Trim()));
            int seperatorIndex = unencryptedToken.IndexOf(':');

            var username = unencryptedToken.Substring(0, seperatorIndex);
            var password = unencryptedToken.Substring(seperatorIndex + 1);

            int result = 0;

            using(SqlConnection conn = new SqlConnection(connectionString))
            using(SqlCommand cmd = new SqlCommand($"SELECT [Admin].[UserValidation]('{username}', '{password}')", conn)) {
                conn.Open();
                result = (int)await cmd.ExecuteScalarAsync();
                conn.Close();
            }

            
        }
    }
}
