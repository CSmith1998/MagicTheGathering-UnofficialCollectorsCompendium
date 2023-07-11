using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using MtG_UCC.Data;
using System.Security.Claims;

using MtG_UCC.Models;
using static MtG_UCC.Services.GlobalMethods;
using System.Net;

namespace MtG_UCC.Controllers {
    public class CollectionController : Controller {
        private readonly UserManager<IdentityUser> context;
        public CollectionController(UserManager<IdentityUser> _context) {
            context = _context;
        }
        public IActionResult Index() {
            return View();
        }

        [Authorize]
        public async Task<IActionResult> Compendium() {
            List<Compendium> UserCompendium = new();

            EstablishClient();
            var authAttempt = await EstablishAuthentication(context, User);
            //UserCompendium.Add(new MtG_UCC.Compendium(authAttempt, "", "", 0));

            if(authAttempt.ContainsKey(HttpStatusCode.OK)) {
                var accountAttempt = await EstablishAccountID(context, User);

                if (accountAttempt.ContainsKey(HttpStatusCode.OK)) {
                    String path = $"UserDetails/GetCompendium";
                    UserCompendium = await RetrieveUserCompendium();
                }

            }

            return View(UserCompendium);
        }

        [Authorize]
        public async Task<IActionResult> Collection(String CardName = null) {
            List<Collection> UserCollection = new();

            EstablishClient();
            var authAttempt = await EstablishAuthentication(context, User);

            if(authAttempt.ContainsKey(HttpStatusCode.OK)) {
                var accountAttempt = await EstablishAccountID(context, User);

                if(accountAttempt.ContainsKey(HttpStatusCode.OK)) {
                    UserCollection = await RetrieveUserCollection(CardName);
                }
            }

            return View(UserCollection);
        }
    }
}
