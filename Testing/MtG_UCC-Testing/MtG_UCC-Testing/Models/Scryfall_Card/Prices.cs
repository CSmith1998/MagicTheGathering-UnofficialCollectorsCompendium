using Newtonsoft.Json;

public class Prices {
        [JsonProperty("usd")]
        public string Usd { get; set; }

        [JsonProperty("usd_foil")]
        public string UsdFoil { get; set; }

        [JsonProperty("usd_etched")]
        public object UsdEtched { get; set; }

        [JsonProperty("eur")]
        public string Eur { get; set; }

        [JsonProperty("eur_foil")]
        public string EurFoil { get; set; }

        [JsonProperty("tix")]
        public string Tix { get; set; }
    }
