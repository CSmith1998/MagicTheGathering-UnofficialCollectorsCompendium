using System;
using System.Collections.Generic;

namespace MtG_UCC.Models
{
    public partial class Price
    {
        public string CardId { get; set; } = null!;
        public decimal? Usd { get; set; }
        public decimal? UsdFoil { get; set; }
        public decimal? UsdEtched { get; set; }
        public decimal? Eur { get; set; }
        public decimal? EurFoil { get; set; }
        public decimal? Tix { get; set; }

        public virtual Card Card { get; set; } = null!;
    }
}
