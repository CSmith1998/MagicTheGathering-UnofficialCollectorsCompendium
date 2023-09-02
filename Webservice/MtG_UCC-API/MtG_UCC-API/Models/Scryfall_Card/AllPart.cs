using System.Text.Json.Serialization;
using Newtonsoft.Json;

namespace MtG_UCC_API.Models.Scryfall_Card{ 

    public class AllPart
    {
        [JsonProperty("object", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("object")]
        public string Object { get; set; }

        [JsonProperty("id", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("id")]
        public string Id { get; set; }

        [JsonProperty("component", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("component")]
        public string Component { get; set; }

        [JsonProperty("name", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("name")]
        public string Name { get; set; }

        [JsonProperty("type_line", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("type_line")]
        public string TypeLine { get; set; }

        [JsonProperty("uri", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("uri")]
        public string Uri { get; set; }
    }

}