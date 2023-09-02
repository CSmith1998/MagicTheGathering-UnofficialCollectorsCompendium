using Newtonsoft.Json;
using System.Text.Json.Serialization;

namespace MtG_UCC_API.Models.Scryfall_Card {
    public class Set {
        [JsonProperty("object", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("object")]
        public string Object { get; set; }

        [JsonProperty("id", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("id")]
        public string Id { get; set; }

        [JsonProperty("code", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("code")]
        public string Code { get; set; }

        [JsonProperty("mtgo_code", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("mtgo_code")]
        public string MtgoCode { get; set; }

        [JsonProperty("arena_code", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("arena_code")]
        public string ArenaCode { get; set; }

        [JsonProperty("tcgplayer_id", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("tcgplayer_id")]
        public int TcgplayerId { get; set; }

        [JsonProperty("name", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("name")]
        public string Name { get; set; }

        [JsonProperty("uri", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("uri")]
        public string Uri { get; set; }

        [JsonProperty("scryfall_uri", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("scryfall_uri")]
        public string ScryfallUri { get; set; }

        [JsonProperty("search_uri", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("search_uri")]
        public string SearchUri { get; set; }

        [JsonProperty("released_at", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("released_at")]
        public string ReleasedAt { get; set; }

        [JsonProperty("set_type", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("set_type")]
        public string SetType { get; set; }

        [JsonProperty("card_count", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("card_count")]
        public int CardCount { get; set; }

        [JsonProperty("printed_size", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("printed_size")]
        public int PrintedSize { get; set; }

        [JsonProperty("digital", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("digital")]
        public bool Digital { get; set; }

        [JsonProperty("nonfoil_only", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("nonfoil_only")]
        public bool NonfoilOnly { get; set; }

        [JsonProperty("foil_only", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("foil_only")]
        public bool FoilOnly { get; set; }

        [JsonProperty("icon_svg_uri", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("icon_svg_uri")]
        public string IconSvgUri { get; set; }
    }
}