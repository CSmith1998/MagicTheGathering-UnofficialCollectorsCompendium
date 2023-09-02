using System.Net.Http.Headers;

namespace MtG_UCC_Testing {
    public static class ServiceMethods {
        public static String AuthEncryption(String username, String password) {
            return (Convert.ToBase64String(System.Text.ASCIIEncoding.UTF8.GetBytes(username + ":" + password)));
        }

        public static Uri CompleteAddress(String baseURL, String Path) { 
            return new Uri(baseURL + "/" + Path);
        }

        public static String CompleteAuthToken(String auth) {
            return ("Basic " + auth);
        }
    }
}
