using System;
using System.Collections.Generic;

namespace MtG_UCC.Models
{
    public partial class ImageUrl
    {
        public string CardId { get; set; } = null!;
        public string FaceName { get; set; } = null!;
        public string? Small { get; set; }
        public string? Normal { get; set; }
        public string? Large { get; set; }
        public string? Png { get; set; }
        public string? ArtCrop { get; set; }
        public string? BorderCrop { get; set; }

        public virtual Card Card { get; set; } = null!;
        public virtual Face FaceNameNavigation { get; set; } = null!;
    }
}
