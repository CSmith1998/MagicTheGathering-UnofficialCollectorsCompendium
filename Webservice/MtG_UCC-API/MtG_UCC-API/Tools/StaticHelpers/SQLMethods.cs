using Microsoft.Data.SqlClient;


using static MtG_UCC_API.ProjectConstants;

namespace MtG_UCC_API {
    public static class SQLMethods {
        public static SqlConnection conn;
        public static SqlCommand cmd;

        public static void CreateSQLConnection() {
            conn = new SqlConnection(connectionString);
        }

        public static async Task<int> EstablishSQLConnection(String SQL) {
            CreateSQLConnection();

            cmd = new SqlCommand($"{SQL}", conn);

            await conn.OpenAsync();

            if(conn.State == System.Data.ConnectionState.Open) {
                return 1;
            } else return 0;
        }

        public static async void EndSQLConnection() {
            await conn.CloseAsync();

            await conn.DisposeAsync();
            await cmd.DisposeAsync();
        }
    }
}
