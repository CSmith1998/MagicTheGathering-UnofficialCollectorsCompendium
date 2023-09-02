using System.Text.Json.Serialization;
using Newtonsoft.Json;

namespace MtG_UCC.Models.Scryfall_Card { 

    public class RelatedUris {
        [JsonProperty("gatherer", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("gatherer")]
        public string Gatherer { get; set; }

        [JsonProperty("tcgplayer_infinite_articles", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("tcgplayer_infinite_articles")]
        public string TcgplayerInfiniteArticles { get; set; }

        [JsonProperty("tcgplayer_infinite_decks", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("tcgplayer_infinite_decks")]
        public string TcgplayerInfiniteDecks { get; set; }

        [JsonProperty("edhrec", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("edhrec")]
        public string Edhrec { get; set; }
    }

}