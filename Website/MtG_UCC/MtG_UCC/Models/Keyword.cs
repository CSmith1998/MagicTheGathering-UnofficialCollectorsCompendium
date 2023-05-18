using System;
using System.Collections.Generic;

namespace MtG_UCC.Models
{
    public partial class Keyword
    {
        public string CardId { get; set; } = null!;
        public string FaceName { get; set; } = null!;
        public string Keyword1 { get; set; } = null!;

        public virtual Card Card { get; set; } = null!;
        public virtual Face FaceNameNavigation { get; set; } = null!;
        public virtual AvailableKeyword Keyword1Navigation { get; set; } = null!;
    }
}
