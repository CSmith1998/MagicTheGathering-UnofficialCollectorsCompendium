using Microsoft.Data.SqlClient;


using static MtG_UCC_Testing.ProjectConstants;

namespace MtG_UCC_Testing {
    public static class SQLMethods {
        public static SqlConnection conn;
        public static SqlCommand cmd;

        public static void CreateSQLConnection() {
            conn = new SqlConnection(connectionString);
        }

        public static void EstablishSQLConnection(String SQL) {
            cmd = new SqlCommand($"{SQL}", conn);

            conn.Open();
        }

        public static void EndSQLConnection() {
            conn.Close();

            conn.Dispose();
            cmd.Dispose();
        }
    }
}
