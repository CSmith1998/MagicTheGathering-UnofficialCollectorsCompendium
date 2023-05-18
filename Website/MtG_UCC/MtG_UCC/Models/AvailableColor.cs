using System;
using System.Collections.Generic;

namespace MtG_UCC.Models
{
    public partial class AvailableColor
    {
        public AvailableColor()
        {
            Colors = new HashSet<Color>();
        }

        public string ColorId { get; set; } = null!;
        public string? ColorName { get; set; }
        public string? LandName { get; set; }

        public virtual ICollection<Color> Colors { get; set; }
    }
}
