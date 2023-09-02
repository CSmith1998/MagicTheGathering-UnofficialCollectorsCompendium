namespace MtG_UCC_API {
    public class Compendium {
        public String ID { get; set; }

        public String CardName { get; set; }
        public String ManaCost { get; set; }

        public String ColorIdentity { get; set; }

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