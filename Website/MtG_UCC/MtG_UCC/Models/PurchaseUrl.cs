using System;
using System.Collections.Generic;

namespace MtG_UCC.Models
{
    public partial class PurchaseUrl
    {
        public string CardId { get; set; } = null!;
        public string? Tcgplayer { get; set; }
        public string? CardMarket { get; set; }
        public string? CardHoarder { get; set; }

        public virtual Card Card { get; set; } = null!;
    }
}
