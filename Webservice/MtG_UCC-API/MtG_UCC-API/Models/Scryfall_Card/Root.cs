using System.Text.Json.Serialization; 
using System.Collections.Generic;
using Newtonsoft.Json;

namespace MtG_UCC_API.Models.Scryfall_Card{ 

    public class Root
    {
        [JsonProperty("object", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("object")]
        public string Object { get; set; }

        [JsonProperty("total_cards", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("total_cards")]
        public int TotalCards { get; set; }

        [JsonProperty("has_more", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("has_more")]
        public bool HasMore { get; set; }

        [JsonProperty("next_page", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("next_page")]
        public string NextPage { get; set; }

        [JsonProperty("data", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("data")]
        public List<Card> Data { get; set; }
    }

}