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

        public override String ToString() {
            StringBuilder ModeSelection = new();

            if(Unique != RollupMode.NONE) {
                if(ModeSelection.Length != 0) { ModeSelection.Append("&"); }
                ModeSelection.Append($"unique={Unique.ToString().ToLower()}");
            }

            if(Sort != SortBy.DEFAULT) { 
                if(ModeSelection.Length != 0) { ModeSelection.Append("&"); }
                ModeSelection.Append($"order={Sort.ToString().ToLower()}");
            }

            if(Order != SortOrder.AUTO) { 
                if(ModeSelection.Length != 0) { ModeSelection.Append("&"); }
                ModeSelection.Append($"dir={Order.ToString().ToLower()}");
            }

            if(ModeSelection.Length != 0) { return $"?{ModeSelection.ToString()}"; }
            else return "";
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
