using Xunit;
using System.Net;
using Microsoft.Data.SqlClient;
using System.Text;

using static MtG_UCC_Testing.ServiceMethods;
using static MtG_UCC_Testing.SQLMethods;

namespace MtG_UCC_Testing.WebServiceTests {
    public class HelperMethods_Testing {
        [Theory,
            InlineData("cls56@students.ptcollege.edu", "AQAAAAEAACcQAAAAEDpQoO+Zb1j4ApshfVSZQiEBpGFLtYYM6TZcAZPA95rwaNns4ZVUC9JwekDF0DDnOw==", true)]
        public async static void TestAuthorization(String baseUser, String basePass, bool shouldPass) {
            int expected; bool result;

            var UserDetails = AuthDecryption(AuthEncryption(baseUser, basePass));

            String username = UserDetails.GetValueOrDefault("Username");
            String password = UserDetails.GetValueOrDefault("Password");

            String SQL = $"SELECT [Admin].[UserValidation]('{username}', '{password}')";

            EstablishSQLConnection(SQL);

            int actual = (int)await cmd.ExecuteScalarAsync();

            if (shouldPass) { expected = 1; result = actual == expected; }
            else { expected = 0; result = actual == expected; }

            Assert.True(result, String.Format("Expected: {0}, Actual: {1}", expected, actual));
        }
    }
}
