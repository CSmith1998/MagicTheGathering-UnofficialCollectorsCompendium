namespace MtG_UCC.Models {
    public class Condition {
        public String ID { get; set; }
        public String Type { get; set; }
        public String Name { get; set; }
        public String Description { get; set; }

        public Condition() { 
        
        }

        public Condition(string iD, string type, string name, string description) {
            ID = iD;
            Type = type;
            Name = name;
            Description = description;
        }
    }
}
