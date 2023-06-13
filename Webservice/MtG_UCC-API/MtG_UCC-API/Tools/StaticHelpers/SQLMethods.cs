using Microsoft.Data.SqlClient;


using static MtG_UCC_API.ProjectConstants;

namespace MtG_UCC_API {
    public static class SQLMethods {
        public static SqlConnection conn;
        public static SqlCommand cmd;

        public static void CreateSQLConnection() {
            conn = new SqlConnection(connectionString);
        }

        public static async void EstablishSQLConnection(String SQL) {
            if(conn == null) {
                CreateSQLConnection();
            }

            cmd = new SqlCommand($"{SQL}", conn);

            await conn.OpenAsync();
        }

        public static async void EndSQLConnection() {
            await conn.CloseAsync();

            await conn.DisposeAsync();
            await cmd.DisposeAsync();
        }
    }
}
