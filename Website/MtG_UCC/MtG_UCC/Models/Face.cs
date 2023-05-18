using System;
using System.Collections.Generic;

namespace MtG_UCC.Models
{
    public partial class Face
    {
        public Face()
        {
            ColorFaceNameNavigations = new HashSet<Color>();
            ColorFaces = new HashSet<Color>();
            ImageUrls = new HashSet<ImageUrl>();
            Keywords = new HashSet<Keyword>();
        }

        public string CardId { get; set; } = null!;
        public string FaceName { get; set; } = null!;
        public string? ManaCost { get; set; }
        public string? TypeLine { get; set; }
        public int? Power { get; set; }
        public int? Toughness { get; set; }
        public string? OracleText { get; set; }
        public string? FlavorText { get; set; }

        public virtual Card Card { get; set; } = null!;
        public virtual ICollection<Color> ColorFaceNameNavigations { get; set; }
        public virtual ICollection<Color> ColorFaces { get; set; }
        public virtual ICollection<ImageUrl> ImageUrls { get; set; }
        public virtual ICollection<Keyword> Keywords { get; set; }
    }
}
