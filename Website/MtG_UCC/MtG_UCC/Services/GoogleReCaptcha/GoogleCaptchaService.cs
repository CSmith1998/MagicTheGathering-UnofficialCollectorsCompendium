using Microsoft.Extensions.Options;
using Newtonsoft.Json;

namespace MtG_UCC.Services.GoogleReCaptcha
{
    public class GoogleCaptchaService
    {
        private readonly IOptionsMonitor<GoogleCaptchaConfig> _config;
        public GoogleCaptchaService(IOptionsMonitor<GoogleCaptchaConfig> config)
        {
            _config = config;
        }

        public async Task<bool> VerifyCaptcha(string captchaResponse) {
            try { 
                var url = $"https://www.google.com/recaptcha/api/siteverify?secret={_config.CurrentValue.SecretKey}&response={captchaResponse}";

                using (var client = new HttpClient()) {
                    var httpResult = await client.GetAsync(url);
                    if(httpResult.StatusCode != System.Net.HttpStatusCode.OK) {
                        return false;
                    }

                    var responseString = await httpResult.Content.ReadAsStringAsync();
                    var googleResult = JsonConvert.DeserializeObject<GoogleCaptchaResponse>(responseString);

                    return googleResult.Success;
                }
            } catch(Exception ex) {
                Console.WriteLine(ex.StackTrace);
                return false;
            }
        }

        public async Task<bool> VerifyToken(string token)
        {
            try {
                var url = $"https://www.google.com/recaptcha/api/siteverify?secret={_config.CurrentValue.SecretKey}&response={token}";

                using( var client = new HttpClient()) {
                    var httpResult = await client.GetAsync(url);
                    if(httpResult.StatusCode != System.Net.HttpStatusCode.OK) {
                        return false;
                    }

                    var responseString = await httpResult.Content.ReadAsStringAsync();
                    var googleResult = JsonConvert.DeserializeObject<GoogleCaptchaResponse>(responseString);

                    return googleResult.Success && googleResult.Score >= 0.5;
                }
            } catch(Exception e) {
                Console.WriteLine(e.StackTrace);
                return false;
            }
        }
    }
}
