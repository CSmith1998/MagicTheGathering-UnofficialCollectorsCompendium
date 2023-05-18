using System;
using System.Collections.Generic;

namespace MtG_UCC.Models
{
    public partial class AvailableFinish
    {
        public AvailableFinish()
        {
            Cards = new HashSet<Card>();
        }

        public string Name { get; set; } = null!;
        public string? Description { get; set; }

        public virtual ICollection<Card> Cards { get; set; }
    }
}
