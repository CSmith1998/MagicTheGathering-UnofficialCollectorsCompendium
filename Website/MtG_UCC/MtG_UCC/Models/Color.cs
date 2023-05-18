using System;
using System.Collections.Generic;

namespace MtG_UCC.Models
{
    public partial class Color
    {
        public string CardId { get; set; } = null!;
        public string FaceName { get; set; } = null!;
        public string ColorId { get; set; } = null!;

        public virtual Card Card { get; set; } = null!;
        public virtual AvailableColor ColorNavigation { get; set; } = null!;
        public virtual Face Face { get; set; } = null!;
        public virtual Face FaceNameNavigation { get; set; } = null!;
    }
}
