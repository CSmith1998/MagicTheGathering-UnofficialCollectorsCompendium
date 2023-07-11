using System;
using System.ComponentModel.DataAnnotations;

namespace MtG_UCC.Models {
    public class Collection : IComparable<Collection> {
        public string CompendiumID { get; set; }
        public string CardID { get; set; }
        public string CardName { get; set; }
        public string CardFace { get; set; }
        public string SetName { get; set; }
        public string SetIcon { get; set; }
        public Condition CardCondition { get; set; }
        public string StorageLocation { get; set; }
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
            CompendiumID = "";
            CardID = "";
            CardName = "";
            CardFace = "";
            SetName = "";
            SetIcon = "";
            CardCondition = new Condition();
            StorageLocation = "";
            Quantity = 0;
        }

        public int CompareTo(Collection other) {
            if (other == null)
                return 1;

            return string.Compare(CardName, other.CardName, StringComparison.OrdinalIgnoreCase);
        }
    }
}
