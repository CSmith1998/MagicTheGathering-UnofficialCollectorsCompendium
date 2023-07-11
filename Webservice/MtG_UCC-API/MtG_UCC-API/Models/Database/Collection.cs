namespace MtG_UCC_API.Models {
    public class Collection {
        public String CompendiumID { get; set; }
        public String CardID { get; set; }
        public String CardName { get; set; }
        public String CardFace { get; set; }
        public String SetName { get; set; }
        public String SetIcon { get; set; }
        public Condition CardCondition { get; set; }
        public String StorageLocation { get; set; }
        public int Quantity { get; set; }

        public Collection(string compendiumID, string cardID, string cardName, string cardFace, string setName, string setIcon, Condition condition, string storageLocation, int quantity) {
            CompendiumID = compendiumID;
            CardID = cardID;
            CardName = cardName;
            CardFace = cardFace;
            SetName = setName;
            SetIcon = setIcon;
            CardCondition = condition;
            StorageLocation = storageLocation;
            Quantity = quantity;
        }

        public Collection() {

        }
    }
}
