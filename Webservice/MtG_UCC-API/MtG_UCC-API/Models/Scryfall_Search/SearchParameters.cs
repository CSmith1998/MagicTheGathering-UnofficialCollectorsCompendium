using Microsoft.IdentityModel.Tokens;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using System.Text;

namespace MtG_UCC_API.Models.Scryfall_Search {
    public class SearchParameters {
        public SearchModes Mode { get; set; }
        public SearchInclusions Inclusions { get; set; }
        public ColorSelection Colors { get; set; }

        public bool ExactName { get; set; }
        public bool Banned { get; set; }

        public String? CardName { get; set; }
        public String? Set { get; set; }

        [JsonConverter(typeof(StringEnumConverter))]
        public Rarities? Rarity { get; set; }
        [JsonConverter(typeof(StringEnumConverter))]
        public Legalities? Legality { get; set; }
        [JsonConverter(typeof(StringEnumConverter))]
        public Languages? Language { get; set; }

        public override String ToString() {
            String mode, inclusions, colors;

            StringBuilder Params = new();
            StringBuilder Details = new();

            mode = Mode.ToString();
            inclusions = Inclusions.ToString();
            colors = Colors.ToString();

            if(!mode.IsNullOrEmpty()) { 
                if(Details.Length != 0) { Details.Append("&"); }

                Details.Append(mode);
            }

            if(!inclusions.IsNullOrEmpty()) { 
                if(Params.Length != 0) { Params.Append("+"); }
                    else { Params.Append("q="); }

                Params.Append(inclusions);
            }

            if(!Set.IsNullOrEmpty()) {
                if(Params.Length != 0) { Params.Append("+"); }
                    else { Params.Append("q="); }

                Params.Append($"set:{Set}");
            }

            if(Rarity != null && Rarity != Rarities.ANY) {
                if(Params.Length != 0) { Params.Append("+"); }
                    else { Params.Append("q="); }

                Params.Append($"rarity:{Rarity.ToString().ToLower()}");
            }

            if(Legality != null && Legality != Legalities.ANY) {
                if(Params.Length != 0) { Params.Append("+"); }
                    else { Params.Append("q="); }

                if(Banned) { Params.Append($"banned:{Legality.ToString().ToLower()}"); }
                else { Params.Append($"format:{Legality.ToString().ToLower()}"); }
            }

            if(Language != null && Language != Languages.ANY) { 
                if(Params.Length != 0) { Params.Append("+"); }
                    else { Params.Append("q="); }

                Params.Append($"language:{Language.ToString().ToLower()}");
            }

            if(!colors.IsNullOrEmpty()) {
                if(Params.Length != 0) { Params.Append("+"); }
                    else { Params.Append("q="); }

                Params.Append(colors);
            }

            if(!CardName.IsNullOrEmpty()) {
                if(Params.Length != 0) { Params.Append("+"); }
                    else { Params.Append("q="); }

                if(ExactName) { Params.Append($"!\"{CardName}\""); }
                    else { Params.Append($"name:\"{CardName}\""); }
            }

            if(Details.Length == 0 || Details == null) {
                return Uri.EscapeUriString($"?{Params.ToString()}");
            } else return Uri.EscapeUriString($"{Details.ToString()}&{Params.ToString()}");
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
