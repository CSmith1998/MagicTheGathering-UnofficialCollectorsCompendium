using Newtonsoft.Json;

namespace MtG_UCC.Models {
    [JsonObject]
    public class Condition {
        [JsonProperty("id")]
        public String ID { get; set; }
        [JsonProperty("type")]
        public String? Type { get; set; }
        [JsonProperty("name")]
        public String? Name { get; set; }
        [JsonProperty("description")]
        public String? Description { get; set; }

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
