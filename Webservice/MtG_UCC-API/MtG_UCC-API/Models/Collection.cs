namespace MtG_UCC_API.Models {
    public class Collection {
        public String CompendiumID { get; set; }
        public String CardID { get; set; }
        public String Condition { get; set; }
        public string StorageLocation { get; set; }
        public int Quantity { get; set; }

        public Collection(string compendiumID, string cardID, string condition, string storageLocation, int quantity) {
            CompendiumID = compendiumID;
            CardID = cardID;
            Condition = condition;
            StorageLocation = storageLocation;
            Quantity = quantity;
        }
    }
}
