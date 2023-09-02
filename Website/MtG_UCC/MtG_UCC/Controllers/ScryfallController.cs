using Microsoft.AspNetCore.Mvc;
using MtG_UCC.Models.Scryfall_Card;
using MtG_UCC.Models.Scryfall_Search;
using static MtG_UCC.Services.GlobalMethods;

namespace MtG_UCC.Controllers {
    public class ScryfallController : Controller {

        public IActionResult Search() {
            List<Card> cards = new();

            SearchParameters parameters = new();

            ViewData["Parameters"] = parameters;

            return View(cards);
        }

        [HttpPost]
        public async Task<IActionResult> Search(SearchParameters parameters) {
            List<Card> cards = new();

            cards = await RetrieveCardsFromSearch(parameters);

            ViewData["Parameters"] = parameters;

            return View(cards);
        }
    }
}
