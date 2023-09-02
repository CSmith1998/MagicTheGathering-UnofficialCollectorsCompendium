using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

using MtG_UCC.Models;
using static MtG_UCC.Services.GlobalMethods;
using System.Net;
using MtG_UCC.Models.Scryfall_Search;
using Newtonsoft.Json;
using MtG_UCC.Models.Scryfall_Card;
using System.Diagnostics;

namespace MtG_UCC.Controllers {
    public class CollectionController : Controller {
        private readonly UserManager<IdentityUser> context;
        public CollectionController(UserManager<IdentityUser> _context) {
            context = _context;
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
        public async Task<IActionResult> Collection(String CardName = null, TrimmedSearch search = null) {
            List<Collection> UserCollection = new();
            if(search == null) { search = new(); }

            ViewData["Parameters"] = search;

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

        [HttpGet, Authorize]
        public async Task<IActionResult> Edit(String json) {
            List<Condition> AvailableGrades = await RetrieveAvailableGrades();

            Collection Record = JsonConvert.DeserializeObject<Collection>(json);

            ViewData["AvailableGrades"] = AvailableGrades;

            return View(Record);
        }

        [HttpPost, Authorize]
        public async Task<IActionResult> Edit(Collection Record) {
            EstablishClient();

            var authAttempt = await EstablishAuthentication(context, User);

            if(authAttempt.ContainsKey(HttpStatusCode.OK)) {
                var accountID = await EstablishAccountID(context, User);

                if(accountID.ContainsKey(HttpStatusCode.OK)) {
                    bool success = await CommitChangesToCollection(Record);

                    CloseClient();

                    if (!success) {
                        ModelState.AddModelError("Error", "An error occured when attempting to submit changes to database!");

                        List<Condition> AvailableGrades = await RetrieveAvailableGrades();
                        ViewData["AvailableGrades"] = AvailableGrades;

                        return View(Record);
                    }
                }
            }

            CloseClient();
            return RedirectToAction("Collection");
        }

        [HttpGet, Authorize]
        public async Task<IActionResult> Create(String json) {
            List<Condition> AvailableGrades = await RetrieveAvailableGrades();
            Collection Record = new();

            Card Prospect = JsonConvert.DeserializeObject<Card>(json);

            Record.CardID = Prospect.Id;
            Record.CardName = Prospect.Name;

            if(Prospect.ImageUris != null) {
                Record.CardFace = Prospect.ImageUris.Png;
            } else {
                Record.CardFace = Prospect.CardFaces[0].ImageUris.Png;
            }

            Record.SetName = Prospect.SetName;
            Record.Quantity = 1;

            ViewData["AvailableGrades"] = AvailableGrades;
            ViewData["Card"] = Prospect;

            return View(Record);
        }

        [HttpPost, Authorize]
        public async Task<IActionResult> Create(Collection Record, String json) {
            Debug.WriteLine($"\n\nJson Data: {json}"); Console.WriteLine($"\n\nJson Data: {json}");
            
            EstablishClient();

            var authAttempt = await EstablishAuthentication(context, User);
            if(authAttempt.ContainsKey(HttpStatusCode.OK)) {
                var accountID = await EstablishAccountID(context, User);

                if(accountID.ContainsKey(HttpStatusCode.OK)) {
                    bool success = await CommitCollectionToDatabase(Record, json);

                    CloseClient();

                    if (!success) {
                        List<Condition> AvailableGrades = await RetrieveAvailableGrades();

                        Card Prospect = new();

                        if(json == null) {
                            Prospect = await RetrieveCardFromID(Record.CardID);
                        } else {
                            Prospect = JsonConvert.DeserializeObject<Card>(json);
                        }

                        ViewData["AvailableGrades"] = AvailableGrades;
                        ViewData["Card"] = Prospect;

                        return View(Record);
                    }
                }
            }

            CloseClient();
            return RedirectToAction("Collection");
        }
    }
}
