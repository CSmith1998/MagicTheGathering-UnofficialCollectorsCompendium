using System.Text.Json.Serialization; 
using Newtonsoft.Json;

using static MtG_UCC.Models.Scryfall_Card.Identities;

namespace MtG_UCC.Models.Scryfall_Card {

    public class Card {
        [JsonProperty("object", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("object")]
        public string Object { get; set; }

        [JsonProperty("id", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("id")]
        public string Id { get; set; }

        [JsonProperty("oracle_id", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("oracle_id")]
        public string OracleId { get; set; }

        [JsonProperty("multiverse_ids", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("multiverse_ids")]
        public List<int> MultiverseIds { get; set; }

        [JsonProperty("mtgo_id", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("mtgo_id")]
        public int MtgoId { get; set; }

        [JsonProperty("mtgo_foil_id", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("mtgo_foil_id")]
        public int MtgoFoilId { get; set; }

        [JsonProperty("tcgplayer_id", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("tcgplayer_id")]
        public int TcgplayerId { get; set; }

        [JsonProperty("cardmarket_id", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("cardmarket_id")]
        public int CardmarketId { get; set; }

        [JsonProperty("name", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("name")]
        public string Name { get; set; }

        [JsonProperty("lang", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("lang")]
        public string Lang { get; set; }

        [JsonProperty("released_at", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("released_at")]
        public string ReleasedAt { get; set; }

        [JsonProperty("uri", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("uri")]
        public string Uri { get; set; }

        [JsonProperty("scryfall_uri", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("scryfall_uri")]
        public string ScryfallUri { get; set; }

        [JsonProperty("layout", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("layout")]
        public string Layout { get; set; }

        [JsonProperty("highres_image", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("highres_image")]
        public bool HighresImage { get; set; }

        [JsonProperty("image_status", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("image_status")]
        public string ImageStatus { get; set; }

        [JsonProperty("cmc", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("cmc")]
        public double Cmc { get; set; }

        [JsonProperty("type_line", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("type_line")]
        public string TypeLine { get; set; }

        [JsonProperty("color_identity", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("color_identity")]
        public List<string> ColorIdentity { get; set; }

        [JsonProperty("keywords", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("keywords")]
        public List<string> Keywords { get; set; }

        [JsonProperty("card_faces", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("card_faces")]
        public List<CardFace> CardFaces { get; set; }

        [JsonProperty("legalities", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("legalities")]
        public Legalities Legalities { get; set; }

        [JsonProperty("games", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("games")]
        public List<string> Games { get; set; }

        [JsonProperty("reserved", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("reserved")]
        public bool Reserved { get; set; }

        [JsonProperty("foil", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("foil")]
        public bool Foil { get; set; }

        [JsonProperty("nonfoil", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("nonfoil")]
        public bool Nonfoil { get; set; }

        [JsonProperty("finishes", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("finishes")]
        public List<string> Finishes { get; set; }

        [JsonProperty("oversized", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("oversized")]
        public bool Oversized { get; set; }

        [JsonProperty("promo", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("promo")]
        public bool Promo { get; set; }

        [JsonProperty("reprint", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("reprint")]
        public bool Reprint { get; set; }

        [JsonProperty("variation", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("variation")]
        public bool Variation { get; set; }

        [JsonProperty("set_id", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("set_id")]
        public string SetId { get; set; }

        [JsonProperty("set", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("set")]
        public string Set { get; set; }

        [JsonProperty("set_name", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("set_name")]
        public string SetName { get; set; }

        [JsonProperty("set_type", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("set_type")]
        public string SetType { get; set; }

        [JsonProperty("set_uri", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("set_uri")]
        public string SetUri { get; set; }

        [JsonProperty("set_search_uri", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("set_search_uri")]
        public string SetSearchUri { get; set; }

        [JsonProperty("scryfall_set_uri", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("scryfall_set_uri")]
        public string ScryfallSetUri { get; set; }

        [JsonProperty("rulings_uri", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("rulings_uri")]
        public string RulingsUri { get; set; }

        [JsonProperty("prints_search_uri", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("prints_search_uri")]
        public string PrintsSearchUri { get; set; }

        [JsonProperty("collector_number", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("collector_number")]
        public string CollectorNumber { get; set; }

        [JsonProperty("digital", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("digital")]
        public bool Digital { get; set; }

        [JsonProperty("rarity", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("rarity")]
        public string Rarity { get; set; }

        [JsonProperty("artist", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("artist")]
        public string Artist { get; set; }

        [JsonProperty("artist_ids", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("artist_ids")]
        public List<string> ArtistIds { get; set; }

        [JsonProperty("border_color", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("border_color")]
        public string BorderColor { get; set; }

        [JsonProperty("frame", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("frame")]
        public string Frame { get; set; }

        [JsonProperty("frame_effects", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("frame_effects")]
        public List<string> FrameEffects { get; set; }

        [JsonProperty("full_art", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("full_art")]
        public bool FullArt { get; set; }

        [JsonProperty("textless", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("textless")]
        public bool Textless { get; set; }

        [JsonProperty("booster", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("booster")]
        public bool Booster { get; set; }

        [JsonProperty("story_spotlight", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("story_spotlight")]
        public bool StorySpotlight { get; set; }

        [JsonProperty("edhrec_rank", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("edhrec_rank")]
        public int EdhrecRank { get; set; }

        [JsonProperty("penny_rank", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("penny_rank")]
        public int PennyRank { get; set; }

        [JsonProperty("prices", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("prices")]
        public Prices Prices { get; set; }

        [JsonProperty("related_uris", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("related_uris")]
        public RelatedUris RelatedUris { get; set; }

        [JsonProperty("purchase_uris", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("purchase_uris")]
        public PurchaseUris PurchaseUris { get; set; }

        [JsonProperty("image_uris", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("image_uris")]
        public ImageUris ImageUris { get; set; }

        [JsonProperty("mana_cost", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("mana_cost")]
        public string ManaCost { get; set; }

        [JsonProperty("oracle_text", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("oracle_text")]
        public string OracleText { get; set; }

        [JsonProperty("colors", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("colors")]
        public List<string> Colors { get; set; }

        [JsonProperty("flavor_text", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("flavor_text")]
        public string FlavorText { get; set; }

        [JsonProperty("card_back_id", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("card_back_id")]
        public string CardBackId { get; set; }

        [JsonProperty("illustration_id", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("illustration_id")]
        public string IllustrationId { get; set; }

        [JsonProperty("power", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("power")]
        public string Power { get; set; }

        [JsonProperty("toughness", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("toughness")]
        public string Toughness { get; set; }

        [JsonProperty("security_stamp", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("security_stamp")]
        public string SecurityStamp { get; set; }

        [JsonProperty("all_parts", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("all_parts")]
        public List<AllPart> AllParts { get; set; }

        [JsonProperty("produced_mana", NullValueHandling = NullValueHandling.Ignore)]
        [JsonPropertyName("produced_mana")]
        public List<string> ProducedMana { get; set; }

        public string? Identity { get; set; }

        public void DetermineIdentity() {
            foreach(var item in AvailableIdentities) { 
                if(item.Key.SequenceEqual(ColorIdentity)) {
                    Identity = item.Value;
                    break;
                }
            }
        }
    }
}