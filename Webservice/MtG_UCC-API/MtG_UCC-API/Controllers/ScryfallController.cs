using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace MtG_UCC_API.Controllers {
    [Route("[controller]/[action]")]
    [ApiController]
    public class ScryfallController : ControllerBase {
        [HttpGet("/{CardID}")]
        public async void GetCardDetails(String CardID) {

        }
    }
}
