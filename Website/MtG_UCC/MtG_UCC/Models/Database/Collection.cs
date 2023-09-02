using Newtonsoft.Json;
using System.Collections;

namespace MtG_UCC.Models {
    [JsonObject]
    public class Collection : IComparable<Collection>, IEnumerable<Collection> {
        [JsonProperty("compendiumID")]
        public string? CompendiumID { get; set; }
        [JsonProperty("cardID")]
        public string CardID { get; set; }
        [JsonProperty("cardName")]
        public string CardName { get; set; }
        [JsonProperty("cardFace")]
        public string CardFace { get; set; }
        [JsonProperty("setName")]
        public string SetName { get; set; }
        [JsonProperty("setIcon")]
        public string? SetIcon { get; set; }
        [JsonProperty("cardCondition")]
        public Condition CardCondition { get; set; }
        [JsonProperty("storageLocation")]
        public string? StorageLocation { get; set; }
        [JsonProperty("quantity")]
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

        public IEnumerator<Collection> GetEnumerator() {
            yield return this;
        }

        IEnumerator IEnumerable.GetEnumerator() {
            return GetEnumerator();
        }
    }
}
