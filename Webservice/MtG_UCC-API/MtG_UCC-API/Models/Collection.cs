namespace MtG_UCC_API.Models {
    public class Collection {
        public String CompendiumID { get; set; }
        public String CardID { get; set; }
        public Condition CardCondition { get; set; }
        public String StorageLocation { get; set; }
        public int Quantity { get; set; }

        public Collection(string compendiumID, string cardID, Condition condition, string storageLocation, int quantity) {
            CompendiumID = compendiumID;
            CardID = cardID;
            CardCondition = condition;
            StorageLocation = storageLocation;
            Quantity = quantity;
        }

        public Collection() {

        }
    }
}
