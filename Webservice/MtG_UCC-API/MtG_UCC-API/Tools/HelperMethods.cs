using Microsoft.Data.SqlClient;

namespace MtG_UCC_API.Tools {
    public static class HelperMethods {
        private static readonly String connectionString = "Server=tcp:enterprise-applications.database.windows.net,1433;Initial Catalog=MtG-UCC-DataRepository;Persist Security Info=False;User ID=SmithCaine;Password=EnterpriseApplications2023;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;";

        public static Dictionary<String, String> GetHeaderValues(IHeaderDictionary dictionary) { 
            Dictionary<String, String> temp = new Dictionary<String, String>();
            foreach(var header in dictionary) {
                temp.Add(header.Key, header.Value);
            }

            return temp;
        }

        public async static Task<bool> Authorization(String AuthToken) {
            if(AuthToken == null) { return false; }

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

            return (result == 1);
        }

        public async static Task<String> GetCompendiumID(String AccountID) {
            String ID = "";

            using(SqlConnection conn = new SqlConnection(connectionString))
            using(SqlCommand cmd = new SqlCommand($"SELECT [User].[GetCompendiumID]('{AccountID}')", conn)) {
                conn.Open();
                ID = (String)await cmd.ExecuteScalarAsync();
                conn.Close();
            }

            return ID;
        }
    }
}
