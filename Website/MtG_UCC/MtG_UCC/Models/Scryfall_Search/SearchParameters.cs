using Microsoft.IdentityModel.Tokens;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace MtG_UCC.Models.Scryfall_Search {
    public class SearchParameters {
        public SearchModes Mode { get; set; }
        public SearchInclusions Inclusions { get; set; }
        public ColorSelection Colors { get; set; }

        [Display(Name = "Exact Name?")]
        public bool ExactName { get; set; }
        [Display(Name = "Banned?")]
        public bool Banned { get; set; }

        [Display(Name = "Card Name:")]
        public String? CardName { get; set; }
        [Display(Name = "Set:")]
        public String? Set { get; set; }

        [JsonConverter(typeof(StringEnumConverter)),
            Display(Name = "Card Rarity:")]
        public Rarities? Rarity { get; set; }
        [JsonConverter(typeof(StringEnumConverter)),
            Display(Name = "Format:")]
        public Legalities? Legality { get; set; }
        [JsonConverter(typeof(StringEnumConverter)),
            Display(Name = "Language:")]
        public Languages? Language { get; set; }

        public SearchParameters() {
            //Mode = new();
            Inclusions = new();
            Colors = new();
        }

        public override string ToString() {
            return JsonConvert.SerializeObject(this);
        }
    }

    public enum Rarities { 
        ANY, COMMON, UNCOMMON, RARE, SPECIAL, MYTHIC, BONUS
    }

    public enum Legalities { 
        ANY, STANDARD, FUTURE, HISTORIC, GLADIATOR, PIONEER, EXPLORER, MODERN, LEGACY, PAUPER, VINTAGE, PENNY, COMMANDER, OATHBREAKER, BRAWL, HISTORIC_BRAWL, ALCHEMY, PAUPER_COMMANDER, DUEL, OLDSCHOOL, PRE_MODERN, PREDH
    }
    public enum Languages { 
        ANY, ENGLISH, SPANISH, FRENCH, GERMAN, ITALIAN, PORTUGUESE, JAPANESE, KOREAN, RUSSIAN, SIMPLIFIED_CHINESE, TRADITIONAL_CHINESE, HEBREW, LATIN, ANCIENT_GREEK, ARABIC, SANSKRIT, PHYREXIAN
    }
}
