using Newtonsoft.Json;

public class RelatedUris {
    [JsonProperty("gatherer")]
    public string Gatherer { get; set; }

    [JsonProperty("edhrec")]
    public string Edhrec { get; set; }
}
