using System.ComponentModel.DataAnnotations;

namespace MtG_UCC.Models.Scryfall_Search {
    public class TrimmedSearch {
        public ColorSelection Colors { get; set; }

        [Display(Name = "Card Name:")]
        public String? CardName { get; set; }
        [Display(Name = "Set:")]
        public String? Set { get; set; }

        public TrimmedSearch(ColorSelection colors, string? cardName, string? set) {
            Colors = colors;
            CardName = cardName;
            Set = set;
        }

        public TrimmedSearch(ColorSelection colors) {
            Colors = colors;
        }

        public TrimmedSearch() {
            Colors = new();
        }
    }
}
