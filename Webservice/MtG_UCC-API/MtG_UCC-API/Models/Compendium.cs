namespace MtG_UCC_API {
    public class Compendium {
        public String ID { get; set; }

        public String CardName { get; set; }

        public String ColorIdentity { get; set; }

        public int TotalQuantity { get; set; }

        public Compendium(string id, string cardName, string colorIdentity, int totalQuantity) {
            ID = id;
            CardName = cardName;
            ColorIdentity = colorIdentity;
            TotalQuantity = totalQuantity;
        }

        public Compendium() {

        }
    }
}