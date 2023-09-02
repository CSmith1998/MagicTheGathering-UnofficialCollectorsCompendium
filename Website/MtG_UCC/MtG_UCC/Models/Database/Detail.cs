namespace MtG_UCC.Models {
    public partial class Detail {
        public Detail() {
            Accesses = new HashSet<Access>();
            Collections = new HashSet<Collection>();
            Compendia = new HashSet<Compendium>();
        }

        public string AccountId { get; set; } = null!;
        public string CompendiumId { get; set; } = null!;
        public string AccessId { get; set; } = null!;

        public virtual AspNetUser Account { get; set; } = null!;
        public virtual ICollection<Access> Accesses { get; set; }
        public virtual ICollection<Collection> Collections { get; set; }
        public virtual ICollection<Compendium> Compendia { get; set; }
    }
}
