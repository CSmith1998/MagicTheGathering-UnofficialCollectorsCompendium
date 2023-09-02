using System.Text.Json.Serialization;
using Newtonsoft.Json;

namespace MtG_UCC_API.Models.Scryfall_Card{ 

    public class PurchaseUris
    {
        [JsonProperty("tcgplayer", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("tcgplayer")]
        public string Tcgplayer { get; set; }

        [JsonProperty("cardmarket", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("cardmarket")]
        public string Cardmarket { get; set; }

        [JsonProperty("cardhoarder", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("cardhoarder")]
        public string Cardhoarder { get; set; }
    }

}