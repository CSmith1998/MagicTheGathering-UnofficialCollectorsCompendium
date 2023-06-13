using System.Text;

namespace MtG_UCC_API.Models.Scryfall_Search {
    public class SearchInclusions {
        public bool IncludeExtras { get; set; }
        public bool IncludeMultilingual { get; set; }
        public bool IncludeVariations { get; set; }

        public SearchInclusions() {
            IncludeExtras = false;
            IncludeMultilingual = false;
            IncludeVariations = false;
        }

        public override String ToString() {
            StringBuilder Inclusions = new();

            if(IncludeExtras) { 
                if(Inclusions.Length != 0) { Inclusions.Append("+"); }
                Inclusions.Append("include:extras");
            }
            if(IncludeMultilingual) { 
                if(Inclusions.Length != 0) { Inclusions.Append("+"); }
                Inclusions.Append("include:multilingual");
            }
            if(IncludeVariations) { 
                if(Inclusions.Length != 0) { Inclusions.Append("+"); }
                Inclusions.Append("include:variations");
            }

            if(Inclusions.Length != 0) { return $"{Inclusions.ToString()}"; }
            else return "";
        }
    }
}
