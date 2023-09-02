using System.ComponentModel.DataAnnotations;

namespace MtG_UCC {
    public class Compendium {
        public String ID { get; set; }

        [Display(Name = "Name")]
        public String CardName { get; set; }

        [Display(Name = "Mana Cost")]
        public String ManaCost { get; set; }

        [Display(Name = "Color Identity")]
        public String ColorIdentity { get; set; }

        [Display(Name = "Quantity")]
        public int TotalQuantity { get; set; }

        public Compendium(string id, string cardName, string manaCost, string colorIdentity, int totalQuantity) {
            ID = id;
            CardName = cardName;
            ManaCost = manaCost;
            ColorIdentity = colorIdentity;
            TotalQuantity = totalQuantity;
        }

        public Compendium() {

        }
    }
}