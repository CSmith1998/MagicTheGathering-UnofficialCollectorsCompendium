using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using System.Text;

namespace MtG_UCC_API.Models.Scryfall_Search {
    public class ColorSelection {
        public bool Containing { get; set; }

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

        public override String ToString() {
            if (Black == ColorOption.UNDECIDED && Green == ColorOption.UNDECIDED && Red == ColorOption.UNDECIDED && Blue == ColorOption.UNDECIDED && White == ColorOption.UNDECIDED) { return ""; }

            if (Black == ColorOption.EXCLUDED || Green == ColorOption.EXCLUDED || Red == ColorOption.EXCLUDED || Blue == ColorOption.EXCLUDED || White == ColorOption.EXCLUDED) {

                StringBuilder ColorsIncluded = new("");
                StringBuilder ColorsExcluded = new();

                if(Black == ColorOption.EXCLUDED) {
                    if(ColorsExcluded.Length != 0) { ColorsExcluded.Append("+"); }
                    ColorsExcluded.Append("-c:b");
                } else if(Black == ColorOption.INCLUDED) { ColorsIncluded.Append("b"); }

                if(Green == ColorOption.EXCLUDED) {
                    if(ColorsExcluded.Length != 0) { ColorsExcluded.Append("+"); }
                    ColorsExcluded.Append("-c:g");
                } else if(Green == ColorOption.INCLUDED) { ColorsIncluded.Append("g"); }

                if(Red == ColorOption.EXCLUDED) { 
                    if(ColorsExcluded.Length != 0) { ColorsExcluded.Append("+"); }
                    ColorsExcluded.Append("-c:r");
                } else if(Red == ColorOption.INCLUDED) { ColorsIncluded.Append("r"); }

                if(Blue == ColorOption.EXCLUDED) { 
                    if(ColorsExcluded.Length != 0) { ColorsExcluded.Append("+"); }
                    ColorsExcluded.Append("-c:u");
                } else if(Blue == ColorOption.INCLUDED) { ColorsIncluded.Append("u"); }

                if(White == ColorOption.EXCLUDED) { 
                    if(ColorsExcluded.Length != 0) { ColorsExcluded.Append("+"); }
                    ColorsExcluded.Append("-c:w");
                } else if(White == ColorOption.INCLUDED) { ColorsIncluded.Append("w"); }

                return $"(c>={ColorsIncluded.ToString()} OR id:{ColorsIncluded.ToString()}) {ColorsExcluded.ToString()}";
            } else {
                StringBuilder ColorSelection = new("");

                if(Black == ColorOption.INCLUDED) { ColorSelection.Append("b"); }
                if(Green == ColorOption.INCLUDED) { ColorSelection.Append("g"); }
                if(Red == ColorOption.INCLUDED) { ColorSelection.Append("r"); }
                if(Blue == ColorOption.INCLUDED) { ColorSelection.Append("u"); }
                if(White == ColorOption.INCLUDED) { ColorSelection.Append("w"); }

                return $"(c:{ColorSelection.ToString()} OR id:{ColorSelection.ToString()})";
            }
        }
    }

    public enum ColorOption { 
        UNDECIDED, INCLUDED, EXCLUDED
    }
}
