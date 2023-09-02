using System.Text.Json.Serialization;
using Newtonsoft.Json;

namespace MtG_UCC_API.Models.Scryfall_Card{ 

    public class Prices
    {
        [JsonProperty("usd", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("usd")]
        public string Usd { get; set; }

        [JsonProperty("usd_foil", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("usd_foil")]
        public string UsdFoil { get; set; }

        [JsonProperty("usd_etched", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("usd_etched")]
        public object UsdEtched { get; set; }

        [JsonProperty("eur", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("eur")]
        public string Eur { get; set; }

        [JsonProperty("eur_foil", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("eur_foil")]
        public string EurFoil { get; set; }

        [JsonProperty("tix", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("tix")]
        public string Tix { get; set; }
    }

}