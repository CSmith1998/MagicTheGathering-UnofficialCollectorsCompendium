using Newtonsoft.Json;

namespace MtG_UCC.Models.Scryfall_Additions {
    public class Set {
        [JsonProperty("id")]
        public string Id { get; set; }

        [JsonProperty("code")]
        public string Code { get; set; }

        [JsonProperty("name")]
        public string Name { get; set; }

        [JsonProperty("icon_svg_uri")]
        public string IconSvgUri { get; set; }
    }
}
