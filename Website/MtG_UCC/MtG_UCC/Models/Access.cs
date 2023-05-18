using System;
using System.Collections.Generic;

namespace MtG_UCC.Models
{
    public partial class Access
    {
        public string Id { get; set; } = null!;
        public string? AccessType { get; set; }
        public string? Ip { get; set; }
        public DateTime Time { get; set; }

        public virtual Detail IdNavigation { get; set; } = null!;
    }
}
