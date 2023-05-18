using System;
using System.Collections.Generic;

namespace MtG_UCC.Models
{
    public partial class CardUrl
    {
        public string CardId { get; set; } = null!;
        public string? Scryfall { get; set; }
        public string? Gatherer { get; set; }
        public string? Edhrec { get; set; }

        public virtual Card Card { get; set; } = null!;
    }
}
