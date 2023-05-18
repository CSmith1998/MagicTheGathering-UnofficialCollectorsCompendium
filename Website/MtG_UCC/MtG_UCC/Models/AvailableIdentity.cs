using System;
using System.Collections.Generic;

namespace MtG_UCC.Models
{
    public partial class AvailableIdentity
    {
        public AvailableIdentity()
        {
            Cards = new HashSet<Card>();
        }

        public string IdentityName { get; set; } = null!;
        public string? Black { get; set; }
        public string? Green { get; set; }
        public string? Red { get; set; }
        public string? Blue { get; set; }
        public string? White { get; set; }

        public virtual ICollection<Card> Cards { get; set; }
    }
}
