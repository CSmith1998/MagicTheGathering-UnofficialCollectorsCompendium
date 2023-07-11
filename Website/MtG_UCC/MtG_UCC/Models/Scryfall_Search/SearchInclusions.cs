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
    }
}
