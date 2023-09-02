using System.Text.Json.Serialization; 
using Newtonsoft.Json;

namespace MtG_UCC.Models.Scryfall_Card { 

    public class CardFace {
        [JsonProperty("object", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("object")]
        public string Object { get; set; }

        [JsonProperty("name", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("name")]
        public string Name { get; set; }

        [JsonProperty("mana_cost", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("mana_cost")]
        public string ManaCost { get; set; }

        [JsonProperty("type_line", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("type_line")]
        public string TypeLine { get; set; }

        [JsonProperty("oracle_text", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("oracle_text")]
        public string OracleText { get; set; }

        [JsonProperty("colors", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("colors")]
        public List<string> Colors { get; set; }

        [JsonProperty("power", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("power")]
        public string Power { get; set; }

        [JsonProperty("toughness", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("toughness")]
        public string Toughness { get; set; }

        [JsonProperty("flavor_text", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("flavor_text")]
        public string FlavorText { get; set; }

        [JsonProperty("artist", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("artist")]
        public string Artist { get; set; }

        [JsonProperty("artist_id", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("artist_id")]
        public string ArtistId { get; set; }

        [JsonProperty("illustration_id", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("illustration_id")]
        public string IllustrationId { get; set; }

        [JsonProperty("image_uris", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("image_uris")]
        public ImageUris ImageUris { get; set; }

        [JsonProperty("flavor_name", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("flavor_name")]
        public string FlavorName { get; set; }

        [JsonProperty("color_indicator", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("color_indicator")]
        public List<string> ColorIndicator { get; set; }

        [JsonProperty("loyalty", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("loyalty")]
        public string Loyalty { get; set; }
    }

}