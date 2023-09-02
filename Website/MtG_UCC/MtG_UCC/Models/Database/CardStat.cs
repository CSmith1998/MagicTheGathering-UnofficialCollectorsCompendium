using System.ComponentModel.DataAnnotations;

namespace MtG_UCC.Models.Database {
    public class CardStat {
        public string CardID { get; set; }
        [Display(Name = "Total Users With Card")]
        public int Count { get; set; }
        public string Name { get; set; }
        public string PNG { get; set; }
        public string SetName { get; set; }
        public string SetIcon { get; set; }
        public string ManaCost { get; set; }
        public string ColorIdentity { get; set; }
    }
}
