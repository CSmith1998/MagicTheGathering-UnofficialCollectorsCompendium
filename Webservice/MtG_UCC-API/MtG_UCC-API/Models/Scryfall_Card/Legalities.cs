using System.Text.Json.Serialization;
using Newtonsoft.Json;

namespace MtG_UCC_API.Models.Scryfall_Card{ 

    public class Legalities
    {
        [JsonProperty("standard", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("standard")]
        public string Standard { get; set; }

        [JsonProperty("future", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("future")]
        public string Future { get; set; }

        [JsonProperty("historic", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("historic")]
        public string Historic { get; set; }

        [JsonProperty("gladiator", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("gladiator")]
        public string Gladiator { get; set; }

        [JsonProperty("pioneer", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("pioneer")]
        public string Pioneer { get; set; }

        [JsonProperty("explorer", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("explorer")]
        public string Explorer { get; set; }

        [JsonProperty("modern", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("modern")]
        public string Modern { get; set; }

        [JsonProperty("legacy", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("legacy")]
        public string Legacy { get; set; }

        [JsonProperty("pauper", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("pauper")]
        public string Pauper { get; set; }

        [JsonProperty("vintage", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("vintage")]
        public string Vintage { get; set; }

        [JsonProperty("penny", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("penny")]
        public string Penny { get; set; }

        [JsonProperty("commander", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("commander")]
        public string Commander { get; set; }

        [JsonProperty("oathbreaker", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("oathbreaker")]
        public string Oathbreaker { get; set; }

        [JsonProperty("brawl", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("brawl")]
        public string Brawl { get; set; }

        [JsonProperty("historicbrawl", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("historicbrawl")]
        public string Historicbrawl { get; set; }

        [JsonProperty("alchemy", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("alchemy")]
        public string Alchemy { get; set; }

        [JsonProperty("paupercommander", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("paupercommander")]
        public string Paupercommander { get; set; }

        [JsonProperty("duel", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("duel")]
        public string Duel { get; set; }

        [JsonProperty("oldschool", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("oldschool")]
        public string Oldschool { get; set; }

        [JsonProperty("premodern", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("premodern")]
        public string Premodern { get; set; }

        [JsonProperty("predh", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("predh")]
        public string Predh { get; set; }
    }

}