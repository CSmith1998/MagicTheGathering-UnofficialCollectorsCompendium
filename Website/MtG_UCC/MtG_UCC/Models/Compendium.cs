using System;
using System.Collections.Generic;

namespace MtG_UCC.Models
{
    public partial class Compendium
    {
        public string Id { get; set; } = null!;
        public string CardName { get; set; } = null!;
        public int? TotalQty { get; set; }

        public virtual Card CardNameNavigation { get; set; } = null!;
        public virtual Detail IdNavigation { get; set; } = null!;
    }
}
