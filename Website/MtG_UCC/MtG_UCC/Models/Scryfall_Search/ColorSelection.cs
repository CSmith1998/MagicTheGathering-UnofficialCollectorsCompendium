using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using System.Text;

namespace MtG_UCC.Models.Scryfall_Search {
    public class ColorSelection {
        [JsonConverter(typeof(StringEnumConverter))]
        public ColorOption Black { get; set; }
        [JsonConverter(typeof(StringEnumConverter))]
        public ColorOption Green { get; set; }
        [JsonConverter(typeof(StringEnumConverter))]
        public ColorOption Red { get; set; }
        [JsonConverter(typeof(StringEnumConverter))]
        public ColorOption Blue { get; set; }
        [JsonConverter(typeof(StringEnumConverter))]
        public ColorOption White { get; set; }

        public ColorSelection() {
            Black = ColorOption.UNDECIDED;
            Green = ColorOption.UNDECIDED;
            Red = ColorOption.UNDECIDED;
            Blue = ColorOption.UNDECIDED;
            White = ColorOption.UNDECIDED;
        }
    }

    public enum ColorOption {
        UNDECIDED, INCLUDED, EXCLUDED
    }
}
