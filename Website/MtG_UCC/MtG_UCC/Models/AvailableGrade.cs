using System;
using System.Collections.Generic;

namespace MtG_UCC.Models
{
    public partial class AvailableGrade
    {
        public AvailableGrade()
        {
            Collections = new HashSet<Collection>();
        }

        public string Id { get; set; } = null!;
        public string? Type { get; set; }
        public string? Name { get; set; }
        public string? Description { get; set; }

        public virtual ICollection<Collection> Collections { get; set; }
    }
}
