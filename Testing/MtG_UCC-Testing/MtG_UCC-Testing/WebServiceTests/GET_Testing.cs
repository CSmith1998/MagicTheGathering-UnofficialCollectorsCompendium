using Xunit;
using System.Net;

using static MtG_UCC_Testing.ServiceMethods;
using static MtG_UCC_Testing.SQLMethods;

namespace MtG_UCC_Testing.WebServiceTests {
    public class GET_Testing : IDisposable {

        GET_Testing() {
            CreateSQLConnection();
        }

        public void Dispose() {
            EndSQLConnection();
        }

        [Theory,
            InlineData("Username", "Password", "UserID", HttpStatusCode.OK),
            InlineData("Username", "Password", "UserID", HttpStatusCode.NotFound)]
        public async void TestGetUserCompendium(String username, String password, String id, HttpStatusCode expectedCode) {
            var AuthToken = CompleteAuthToken(AuthEncryption(username, password));
            var RequestURI = CompleteAddress("UserDetails/GetCompendium");

            var response = await GenerateResponse(HttpMethod.Get, RequestURI, AuthToken, id);

            var isTrue = response.StatusCode == expectedCode;
            Assert.True(isTrue, response.StatusCode.ToString());
        }

        [Theory,
            InlineData("Username", "Password", "UserID", "CardID", HttpStatusCode.OK),
            InlineData("Username", "Password", "UserID", "CardID", HttpStatusCode.NotFound)]
        public async void TestGetUserCollection(String username, String password, String id, String cardID, HttpStatusCode expectedCode) {
            var AuthToken = CompleteAuthToken(AuthEncryption(username, password));
            var RequestURI = CompleteAddress($"UserDetails/GetCollection/{cardID}");

            var response = await GenerateResponse(HttpMethod.Get, RequestURI, AuthToken, id);

            var isTrue = response.StatusCode == expectedCode;
            Assert.True(isTrue, response.StatusCode.ToString());
        }

        [Theory,
            InlineData("CardID", HttpStatusCode.OK),
            InlineData("CardID", HttpStatusCode.NotFound)]
        public async void TestGetCardDetails(String cardID, HttpStatusCode expectedCode) {
            var RequestURI = CompleteAddress($"UserDetails/GetCardDetails/{cardID}");

            var response = await GenerateResponse(HttpMethod.Get, RequestURI);

            var isTrue = response.StatusCode == expectedCode;
            Assert.True(isTrue, response.StatusCode.ToString());
        }

        [Theory,
            InlineData("CardID", "ExpectedJSON")]
        public async void TestReceivedCardDetails(String cardID, String expectedJSON) {
            var RequestURI = CompleteAddress($"UserDetails/GetCardDetails/{cardID}");

            var response = await GenerateResponse(HttpMethod.Get, RequestURI);
            var message = await response.Content.ReadAsStringAsync();

            var isTrue = message.Equals(expectedJSON);
            Assert.True(isTrue, String.Format("Status Code: {0}\nExpected: {1}\tActual: {2}", response.StatusCode.ToString(), expectedJSON, message));
        }

        [Theory,
            InlineData("f97c771c-95f5-492d-a0b8-d25db8300678", "UCf97c-0678_0")]
        public async static void TestGetCompendiumID(String AccountID, String expected) {
            String SQL = $"SELECT [User].[GetCompendiumID]('{AccountID}')";

            EstablishSQLConnection(SQL);

            String actual = (String)await cmd.ExecuteScalarAsync();

            bool result = (expected.Equals(actual));

            Assert.True(result, $"Expected: {expected}, Actual: {actual}");
        }
    }
}
