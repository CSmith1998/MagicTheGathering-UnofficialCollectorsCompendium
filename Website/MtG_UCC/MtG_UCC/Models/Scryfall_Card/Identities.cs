namespace MtG_UCC.Models.Scryfall_Card {
    public static class Identities {
        public static Dictionary<List<string>, string> AvailableIdentities = new() {
            { new() { "B" }, "Mono Black" },
            { new() { "G" }, "Mono Green" },
            { new() { "R" }, "Mono Red" },
            { new() { "U" }, "Mono Blue" },
            { new() { "W" }, "Mono White" },

            { new() { "U", "W" }, "Azorius" },
            { new() { "R", "W" }, "Boros" },
            { new() { "B", "U" }, "Dimir" },
            { new() { "B", "G" }, "Golgari" },
            { new() { "G", "R" }, "Gruul" },
            { new() { "R", "U" }, "Izzet" },
            { new() { "B", "W" }, "Orzhov" },
            { new() { "B", "R" }, "Rakdos" },
            { new() { "G", "W" }, "Selesnya" },
            { new() { "G", "U" }, "Simic" },

            { new() { "B", "G", "W" }, "Abzan" },
            { new() { "G", "U", "W" }, "Bant" },
            { new() { "B", "U", "W" }, "Esper" },
            { new() { "B", "R", "U" }, "Grixis" },
            { new() { "R", "U", "W" }, "Jeskai" },
            { new() { "B", "G", "R" }, "Jund" },
            { new() { "B", "R", "W" }, "Mardu" },
            { new() { "G", "R", "W" }, "Naya" },
            { new() { "B", "G", "U" }, "Sultai" },
            { new() { "G", "R", "U" }, "Temur" },

            { new() { "B", "G", "R", "U" }, "Glint" },
            { new() { "B", "G", "R", "W" }, "Dune" },
            { new() { "G", "R", "U", "W" }, "Ink" },
            { new() { "B", "G", "U", "W" }, "Witch" },
            { new() { "B", "R", "U", "W" }, "Yore" },

            { new() { "B", "G", "R", "U", "W" }, "Rainbow" },
        };
    }
}
