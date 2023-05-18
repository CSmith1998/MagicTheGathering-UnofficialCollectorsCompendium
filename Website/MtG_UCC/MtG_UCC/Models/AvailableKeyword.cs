using System;
using System.Collections.Generic;

namespace MtG_UCC.Models
{
    public partial class AvailableKeyword
    {
        public AvailableKeyword()
        {
            Keywords = new HashSet<Keyword>();
        }

        public string Keyword { get; set; } = null!;
        public string? Description { get; set; }

        public virtual ICollection<Keyword> Keywords { get; set; }
    }
}
