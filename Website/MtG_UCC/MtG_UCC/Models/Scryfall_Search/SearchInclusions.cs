using System.ComponentModel.DataAnnotations;
using System.Text;

namespace MtG_UCC.Models.Scryfall_Search {
    public class SearchInclusions {
        [Display(Name = "Extras?")]
        public bool IncludeExtras { get; set; }
        [Display(Name = "Multilingual?")]
        public bool IncludeMultilingual { get; set; }
        [Display(Name = "Variations?")]
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
