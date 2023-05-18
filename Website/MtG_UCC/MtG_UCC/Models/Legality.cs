﻿using System;
using System.Collections.Generic;

namespace MtG_UCC.Models
{
    public partial class Legality
    {
        public string CardId { get; set; } = null!;
        public string? Standard { get; set; }
        public string? Future { get; set; }
        public string? Historic { get; set; }
        public string? Gladiator { get; set; }
        public string? Pioneer { get; set; }
        public string? Explorer { get; set; }
        public string? Modern { get; set; }
        public string? Legacy { get; set; }
        public string? Pauper { get; set; }
        public string? Vintage { get; set; }
        public string? Penny { get; set; }
        public string? Commander { get; set; }
        public string? Oathbreaker { get; set; }
        public string? Brawl { get; set; }
        public string? HistoricBrawl { get; set; }
        public string? Alchemy { get; set; }
        public string? PauperCommander { get; set; }
        public string? Duel { get; set; }
        public string? Oldschool { get; set; }
        public string? Premodern { get; set; }
        public string? Predh { get; set; }

        public virtual Card Card { get; set; } = null!;
    }
}
