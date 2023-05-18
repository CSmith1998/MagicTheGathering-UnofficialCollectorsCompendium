using System;
using System.Collections.Generic;

namespace MtG_UCC.Models
{
    public partial class Card
    {
        public Card()
        {
            Collections = new HashSet<Collection>();
            Colors = new HashSet<Color>();
            Compendia = new HashSet<Compendium>();
            Faces = new HashSet<Face>();
            ImageUrls = new HashSet<ImageUrl>();
            Keywords = new HashSet<Keyword>();
            FinishNames = new HashSet<AvailableFinish>();
        }

        public string Id { get; set; } = null!;
        public string Name { get; set; } = null!;
        public DateTime? ReleasedAt { get; set; }
        public string? Layout { get; set; }
        public decimal? ConvertedManaCost { get; set; }
        public string? ColorIdentity { get; set; }
        public string? TypeLine { get; set; }
        public string? Reserved { get; set; }
        public string? Foil { get; set; }
        public string? Nonfoil { get; set; }
        public string? Oversized { get; set; }
        public string? Promo { get; set; }
        public string? Reprint { get; set; }
        public string? SetId { get; set; }
        public string? RulingsUrl { get; set; }
        public string? Rarity { get; set; }
        public string? Artist { get; set; }
        public string? FullArt { get; set; }
        public string? Textless { get; set; }

        public virtual AvailableIdentity? ColorIdentityNavigation { get; set; }
        public virtual AvailableSet? Set { get; set; }
        public virtual CardUrl? CardUrl { get; set; }
        public virtual Legality? Legality { get; set; }
        public virtual Price? Price { get; set; }
        public virtual PurchaseUrl? PurchaseUrl { get; set; }
        public virtual ICollection<Collection> Collections { get; set; }
        public virtual ICollection<Color> Colors { get; set; }
        public virtual ICollection<Compendium> Compendia { get; set; }
        public virtual ICollection<Face> Faces { get; set; }
        public virtual ICollection<ImageUrl> ImageUrls { get; set; }
        public virtual ICollection<Keyword> Keywords { get; set; }

        public virtual ICollection<AvailableFinish> FinishNames { get; set; }
    }
}
