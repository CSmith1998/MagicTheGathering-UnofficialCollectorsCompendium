using System.Net.Http.Headers;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using MtG_UCC_API.Models;
using static System.Net.Http.Headers.HttpRequestHeaders;
using static MtG_UCC_API.Tools.HelperMethods;

namespace MtG_UCC_API.Controllers
{
    [ApiController]
    [Route("[controller]/[action]")]
    public class UserDetailsController : ControllerBase {
        private readonly ILogger<UserDetailsController> _logger;

        public UserDetailsController(ILogger<UserDetailsController> logger) {
            _logger = logger;
        }

        //[HttpGet(Name = "GetWeatherForecast")]
        [HttpGet]
        public async void GetCompendium() {
            Dictionary<String, String> headers = GetHeaderValues(this.Request.Headers);

            if (await Authorization(headers.GetValueOrDefault("Authorization"))) {
                var compendiumID = await GetCompendiumID(headers.GetValueOrDefault("AccountID"));

                if(compendiumID.IsNullOrEmpty) { 
                    //return not found
                }



            } //return unauthorized
        }

        [HttpGet("/{CardID}")]  
        public async void GetCollection(String CardID) {
            Dictionary<String, String> headers = GetHeaderValues(this.Request.Headers);

            if (await Authorization(headers.GetValueOrDefault("Authorization"))) {

            }
        }
    }
}