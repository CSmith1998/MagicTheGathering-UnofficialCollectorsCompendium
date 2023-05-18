using System;
using System.Collections.Generic;

namespace MtG_UCC.Models
{
    public partial class Collection
    {
        public string CompendiumId { get; set; } = null!;
        public string CardId { get; set; } = null!;
        public string Condition { get; set; } = null!;
        public string StorageLocation { get; set; } = null!;
        public int? Quantity { get; set; }

        public virtual Card Card { get; set; } = null!;
        public virtual Detail Compendium { get; set; } = null!;
        public virtual AvailableGrade ConditionNavigation { get; set; } = null!;
    }
}
