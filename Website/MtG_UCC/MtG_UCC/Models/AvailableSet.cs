using System;
using System.Collections.Generic;

namespace MtG_UCC.Models
{
    public partial class AvailableSet
    {
        public AvailableSet()
        {
            Cards = new HashSet<Card>();
        }

        public string Id { get; set; } = null!;
        public string? SetCode { get; set; }
        public string? SetName { get; set; }
        public string? SetType { get; set; }
        public string? Released { get; set; }
        public string? SymbolUrl { get; set; }

        public virtual ICollection<Card> Cards { get; set; }
    }
}
