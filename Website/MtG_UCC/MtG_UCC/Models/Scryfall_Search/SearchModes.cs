using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace MtG_UCC.Models.Scryfall_Search {
    public class SearchModes {
        [JsonConverter(typeof(StringEnumConverter)),
            Display(Name = "Display Unique:")]
        public RollupMode Unique { get; set; }
        [JsonConverter(typeof(StringEnumConverter)),
            Display(Name = "Sort By:")]
        public SortBy Sort { get; set; }
        [JsonConverter(typeof(StringEnumConverter)),
            Display(Name = "Sort Order:")]
        public SortOrder Order { get; set; }

        public SearchModes() {
            Unique = RollupMode.PRINTS;
            Sort = SortBy.NAME;
            Order = SortOrder.AUTO;
        }
    }

    public enum RollupMode { 
        NONE, CARDS, ART, PRINTS
    }

    public enum SortBy { 
        DEFAULT, NAME, SET, RELEASED, RARITY, COLOR, USD, TIX, EUR, CMC, POWER, TOUGHNESS, EDHREC, PENNY, ARTIST, REVIEW
    }

    public enum SortOrder { 
        AUTO, ASCENDING, DESCENDING
    }
}
