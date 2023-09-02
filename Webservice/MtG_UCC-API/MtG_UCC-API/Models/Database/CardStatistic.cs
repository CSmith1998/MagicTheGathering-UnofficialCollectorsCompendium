namespace MtG_UCC_API.Models.Database {
    public class CardStatistic {
        public string CardID { get; set; }
        public int Count { get; set; }
        public string Name { get; set; }
        public string PNG { get; set; }
        public string SetName { get; set; }
        public string SetIcon { get; set; }
        public string ManaCost { get; set; }
        public string ColorIdentity { get; set; }

        public CardStatistic(String message, int code = 0) {
            CardID = message;
            Count = code;
            Name = "";
            PNG = "";
            SetName = "";
            SetIcon = "";
            ManaCost = "";
            ColorIdentity = "";
        }

        public CardStatistic(string cardID, int count, string name, string pNG, string setName, string setIcon, string manaCost, string colorIdentity) {
            CardID = cardID;
            Count = count;
            Name = name;
            PNG = pNG;
            SetName = setName;
            SetIcon = setIcon;
            ManaCost = manaCost;
            ColorIdentity = colorIdentity;
        }

        public CardStatistic() { }
    }
}
