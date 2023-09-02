using System.Text.Json.Serialization;
using Newtonsoft.Json;

namespace MtG_UCC.Models.Scryfall_Card { 

    public class ImageUris {
        [JsonProperty("small", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("small")]
        public string Small { get; set; }

        [JsonProperty("normal", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("normal")]
        public string Normal { get; set; }

        [JsonProperty("large", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("large")]
        public string Large { get; set; }

        [JsonProperty("png", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("png")]
        public string Png { get; set; }

        [JsonProperty("art_crop", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("art_crop")]
        public string ArtCrop { get; set; }

        [JsonProperty("border_crop", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("border_crop")]
        public string BorderCrop { get; set; }
    }

}