using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using static System.Net.WebRequestMethods;

namespace MtG_UCC_Testing {
    public static class ProjectConstants {
        private static readonly String _connString = "Server=tcp:enterprise-applications.database.windows.net,1433;Initial Catalog=MtG-UCC-DataRepository;Persist Security Info=False;User ID=SmithCaine;Password=EnterpriseApplications2023;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;";

        private static readonly int port = 5045;
        private static readonly String _baseURL = "http://localhost:";

        public static String connectionString {
            get { return _connString; }
        }

        public static String baseURL { 
            get { return $"{_baseURL}{port}"; }
        }
    }
}
