using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

namespace MtG_UCC.Models
{
    public partial class MtG_UCC_Context : DbContext
    {
        public MtG_UCC_Context()
        {
        }

        public MtG_UCC_Context(DbContextOptions<MtG_UCC_Context> options)
            : base(options)
        {
        }

        public virtual DbSet<Access> Accesses { get; set; } = null!;
        public virtual DbSet<AspNetRole> AspNetRoles { get; set; } = null!;
        public virtual DbSet<AspNetRoleClaim> AspNetRoleClaims { get; set; } = null!;
        public virtual DbSet<AspNetUser> AspNetUsers { get; set; } = null!;
        public virtual DbSet<AspNetUserClaim> AspNetUserClaims { get; set; } = null!;
        public virtual DbSet<AspNetUserLogin> AspNetUserLogins { get; set; } = null!;
        public virtual DbSet<AspNetUserToken> AspNetUserTokens { get; set; } = null!;
        public virtual DbSet<AvailableColor> AvailableColors { get; set; } = null!;
        public virtual DbSet<AvailableFinish> AvailableFinishes { get; set; } = null!;
        public virtual DbSet<AvailableGrade> AvailableGrades { get; set; } = null!;
        public virtual DbSet<AvailableIdentity> AvailableIdentities { get; set; } = null!;
        public virtual DbSet<AvailableKeyword> AvailableKeywords { get; set; } = null!;
        public virtual DbSet<AvailableSet> AvailableSets { get; set; } = null!;
        public virtual DbSet<Card> Cards { get; set; } = null!;
        public virtual DbSet<CardUrl> CardUrls { get; set; } = null!;
        public virtual DbSet<Collection> Collections { get; set; } = null!;
        public virtual DbSet<Color> Colors { get; set; } = null!;
        public virtual DbSet<Compendium> Compendia { get; set; } = null!;
        public virtual DbSet<Detail> Details { get; set; } = null!;
        public virtual DbSet<Face> Faces { get; set; } = null!;
        public virtual DbSet<ImageUrl> ImageUrls { get; set; } = null!;
        public virtual DbSet<Keyword> Keywords { get; set; } = null!;
        public virtual DbSet<Legality> Legalities { get; set; } = null!;
        public virtual DbSet<Price> Prices { get; set; } = null!;
        public virtual DbSet<PurchaseUrl> PurchaseUrls { get; set; } = null!;

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Access>(entity =>
            {
                entity.HasKey(e => new { e.Id, e.Time })
                    .HasName("CPK_UserAccess");

                entity.ToTable("Access", "User");

                entity.Property(e => e.Id)
                    .HasMaxLength(45)
                    .IsUnicode(false)
                    .HasColumnName("ID");

                entity.Property(e => e.Time).HasColumnType("datetime");

                entity.Property(e => e.AccessType)
                    .HasMaxLength(256)
                    .IsUnicode(false);

                entity.Property(e => e.Ip)
                    .HasMaxLength(36)
                    .IsUnicode(false)
                    .HasColumnName("IP");

                entity.HasOne(d => d.IdNavigation)
                    .WithMany(p => p.Accesses)
                    .HasPrincipalKey(p => p.AccessId)
                    .HasForeignKey(d => d.Id)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Access__ID__03FB8544");
            });

            modelBuilder.Entity<AspNetRole>(entity =>
            {
                entity.ToTable("AspNetRoles", "Admin");

                entity.HasIndex(e => e.NormalizedName, "RoleNameIndex")
                    .IsUnique()
                    .HasFilter("([NormalizedName] IS NOT NULL)");

                entity.Property(e => e.Name).HasMaxLength(256);

                entity.Property(e => e.NormalizedName).HasMaxLength(256);
            });

            modelBuilder.Entity<AspNetRoleClaim>(entity =>
            {
                entity.ToTable("AspNetRoleClaims", "Admin");

                entity.HasIndex(e => e.RoleId, "IX_AspNetRoleClaims_RoleId");

                entity.HasOne(d => d.Role)
                    .WithMany(p => p.AspNetRoleClaims)
                    .HasForeignKey(d => d.RoleId);
            });

            modelBuilder.Entity<AspNetUser>(entity =>
            {
                entity.ToTable("AspNetUsers", "Admin");

                entity.HasIndex(e => e.NormalizedEmail, "EmailIndex");

                entity.HasIndex(e => e.NormalizedUserName, "UserNameIndex")
                    .IsUnique()
                    .HasFilter("([NormalizedUserName] IS NOT NULL)");

                entity.Property(e => e.Email).HasMaxLength(256);

                entity.Property(e => e.NormalizedEmail).HasMaxLength(256);

                entity.Property(e => e.NormalizedUserName).HasMaxLength(256);

                entity.Property(e => e.UserName).HasMaxLength(256);

                entity.HasMany(d => d.Roles)
                    .WithMany(p => p.Users)
                    .UsingEntity<Dictionary<string, object>>(
                        "AspNetUserRole",
                        l => l.HasOne<AspNetRole>().WithMany().HasForeignKey("RoleId"),
                        r => r.HasOne<AspNetUser>().WithMany().HasForeignKey("UserId"),
                        j =>
                        {
                            j.HasKey("UserId", "RoleId");

                            j.ToTable("AspNetUserRoles", "Admin");

                            j.HasIndex(new[] { "RoleId" }, "IX_AspNetUserRoles_RoleId");
                        });
            });

            modelBuilder.Entity<AspNetUserClaim>(entity =>
            {
                entity.ToTable("AspNetUserClaims", "Admin");

                entity.HasIndex(e => e.UserId, "IX_AspNetUserClaims_UserId");

                entity.HasOne(d => d.User)
                    .WithMany(p => p.AspNetUserClaims)
                    .HasForeignKey(d => d.UserId);
            });

            modelBuilder.Entity<AspNetUserLogin>(entity =>
            {
                entity.HasKey(e => new { e.LoginProvider, e.ProviderKey });

                entity.ToTable("AspNetUserLogins", "Admin");

                entity.HasIndex(e => e.UserId, "IX_AspNetUserLogins_UserId");

                entity.Property(e => e.LoginProvider).HasMaxLength(128);

                entity.Property(e => e.ProviderKey).HasMaxLength(128);

                entity.HasOne(d => d.User)
                    .WithMany(p => p.AspNetUserLogins)
                    .HasForeignKey(d => d.UserId);
            });

            modelBuilder.Entity<AspNetUserToken>(entity =>
            {
                entity.HasKey(e => new { e.UserId, e.LoginProvider, e.Name });

                entity.ToTable("AspNetUserTokens", "Admin");

                entity.Property(e => e.LoginProvider).HasMaxLength(128);

                entity.Property(e => e.Name).HasMaxLength(128);

                entity.HasOne(d => d.User)
                    .WithMany(p => p.AspNetUserTokens)
                    .HasForeignKey(d => d.UserId);
            });

            modelBuilder.Entity<AvailableColor>(entity =>
            {
                entity.HasKey(e => e.ColorId)
                    .HasName("PK__Availabl__8DA7676DDF406484");

                entity.ToTable("AvailableColors", "MtG");

                entity.HasIndex(e => e.ColorName, "UQ__Availabl__C71A5A7BB33EBEEE")
                    .IsUnique();

                entity.HasIndex(e => e.LandName, "UQ__Availabl__FB988F35B62B1EBA")
                    .IsUnique();

                entity.Property(e => e.ColorId)
                    .HasMaxLength(1)
                    .IsUnicode(false)
                    .HasColumnName("ColorID")
                    .IsFixedLength();

                entity.Property(e => e.ColorName)
                    .HasMaxLength(5)
                    .IsUnicode(false);

                entity.Property(e => e.LandName)
                    .HasMaxLength(8)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<AvailableFinish>(entity =>
            {
                entity.HasKey(e => e.Name)
                    .HasName("PK__Availabl__737584F77B8EC015");

                entity.ToTable("AvailableFinishes", "MtG");

                entity.Property(e => e.Name)
                    .HasMaxLength(8)
                    .IsUnicode(false);

                entity.Property(e => e.Description)
                    .HasMaxLength(450)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<AvailableGrade>(entity =>
            {
                entity.ToTable("AvailableGrades", "MtG");

                entity.Property(e => e.Id)
                    .HasMaxLength(12)
                    .IsUnicode(false)
                    .HasColumnName("ID");

                entity.Property(e => e.Description).IsUnicode(false);

                entity.Property(e => e.Name)
                    .HasMaxLength(20)
                    .IsUnicode(false);

                entity.Property(e => e.Type)
                    .HasMaxLength(10)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<AvailableIdentity>(entity =>
            {
                entity.HasKey(e => e.IdentityName)
                    .HasName("PK__Availabl__F894E98C53735C22");

                entity.ToTable("AvailableIdentities", "MtG");

                entity.Property(e => e.IdentityName)
                    .HasMaxLength(10)
                    .IsUnicode(false);

                entity.Property(e => e.Black)
                    .HasMaxLength(1)
                    .HasDefaultValueSql("('N')")
                    .IsFixedLength();

                entity.Property(e => e.Blue)
                    .HasMaxLength(1)
                    .HasDefaultValueSql("('N')")
                    .IsFixedLength();

                entity.Property(e => e.Green)
                    .HasMaxLength(1)
                    .HasDefaultValueSql("('N')")
                    .IsFixedLength();

                entity.Property(e => e.Red)
                    .HasMaxLength(1)
                    .HasDefaultValueSql("('N')")
                    .IsFixedLength();

                entity.Property(e => e.White)
                    .HasMaxLength(1)
                    .HasDefaultValueSql("('N')")
                    .IsFixedLength();
            });

            modelBuilder.Entity<AvailableKeyword>(entity =>
            {
                entity.HasKey(e => e.Keyword)
                    .HasName("PK__Availabl__1D3264F7D03885DB");

                entity.ToTable("AvailableKeywords", "MtG");

                entity.Property(e => e.Keyword)
                    .HasMaxLength(25)
                    .IsUnicode(false);

                entity.Property(e => e.Description).IsUnicode(false);
            });

            modelBuilder.Entity<AvailableSet>(entity =>
            {
                entity.ToTable("AvailableSets", "MtG");

                entity.Property(e => e.Id)
                    .HasMaxLength(36)
                    .IsUnicode(false)
                    .HasColumnName("ID");

                entity.Property(e => e.Released)
                    .HasMaxLength(20)
                    .IsUnicode(false)
                    .HasDefaultValueSql("('Missing')");

                entity.Property(e => e.SetCode)
                    .HasMaxLength(10)
                    .IsUnicode(false);

                entity.Property(e => e.SetName)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.SetType)
                    .HasMaxLength(25)
                    .IsUnicode(false);

                entity.Property(e => e.SymbolUrl)
                    .HasMaxLength(250)
                    .IsUnicode(false)
                    .HasDefaultValueSql("('Missing')");
            });

            modelBuilder.Entity<Card>(entity =>
            {
                entity.ToTable("Card", "MtG");

                entity.HasIndex(e => e.Name, "UQ__Card__737584F638DFC1A6")
                    .IsUnique();

                entity.Property(e => e.Id)
                    .HasMaxLength(36)
                    .IsUnicode(false)
                    .HasColumnName("ID");

                entity.Property(e => e.Artist)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.ColorIdentity)
                    .HasMaxLength(10)
                    .IsUnicode(false);

                entity.Property(e => e.ConvertedManaCost).HasColumnType("decimal(3, 1)");

                entity.Property(e => e.Foil)
                    .HasMaxLength(1)
                    .HasDefaultValueSql("('N')")
                    .IsFixedLength();

                entity.Property(e => e.FullArt)
                    .HasMaxLength(1)
                    .HasDefaultValueSql("('N')")
                    .IsFixedLength();

                entity.Property(e => e.Layout)
                    .HasMaxLength(25)
                    .IsUnicode(false)
                    .HasDefaultValueSql("('Normal')");

                entity.Property(e => e.Name)
                    .HasMaxLength(141)
                    .IsUnicode(false);

                entity.Property(e => e.Nonfoil)
                    .HasMaxLength(1)
                    .HasDefaultValueSql("('Y')")
                    .IsFixedLength();

                entity.Property(e => e.Oversized)
                    .HasMaxLength(1)
                    .HasDefaultValueSql("('N')")
                    .IsFixedLength();

                entity.Property(e => e.Promo)
                    .HasMaxLength(1)
                    .HasDefaultValueSql("('N')")
                    .IsFixedLength();

                entity.Property(e => e.Rarity)
                    .HasMaxLength(12)
                    .IsUnicode(false)
                    .HasDefaultValueSql("('Common')");

                entity.Property(e => e.ReleasedAt).HasColumnType("date");

                entity.Property(e => e.Reprint)
                    .HasMaxLength(1)
                    .HasDefaultValueSql("('N')")
                    .IsFixedLength();

                entity.Property(e => e.Reserved)
                    .HasMaxLength(1)
                    .HasDefaultValueSql("('N')")
                    .IsFixedLength();

                entity.Property(e => e.RulingsUrl)
                    .HasMaxLength(250)
                    .IsUnicode(false)
                    .HasColumnName("RulingsURL");

                entity.Property(e => e.SetId)
                    .HasMaxLength(36)
                    .IsUnicode(false)
                    .HasColumnName("SetID");

                entity.Property(e => e.Textless)
                    .HasMaxLength(1)
                    .HasDefaultValueSql("('N')")
                    .IsFixedLength();

                entity.Property(e => e.TypeLine)
                    .HasMaxLength(150)
                    .IsUnicode(false);

                entity.HasOne(d => d.ColorIdentityNavigation)
                    .WithMany(p => p.Cards)
                    .HasForeignKey(d => d.ColorIdentity)
                    .HasConstraintName("FK__Card__ColorIdent__61A66D40");

                entity.HasOne(d => d.Set)
                    .WithMany(p => p.Cards)
                    .HasForeignKey(d => d.SetId)
                    .HasConstraintName("FK__Card__SetID__68536ACF");

                entity.HasMany(d => d.FinishNames)
                    .WithMany(p => p.Cards)
                    .UsingEntity<Dictionary<string, object>>(
                        "Finish",
                        l => l.HasOne<AvailableFinish>().WithMany().HasForeignKey("FinishName").OnDelete(DeleteBehavior.ClientSetNull).HasConstraintName("FK__Finishes__Finish__41049384"),
                        r => r.HasOne<Card>().WithMany().HasForeignKey("CardId").OnDelete(DeleteBehavior.ClientSetNull).HasConstraintName("FK__Finishes__CardID__40106F4B"),
                        j =>
                        {
                            j.HasKey("CardId", "FinishName").HasName("CPK_CardFinishes");

                            j.ToTable("Finishes", "MtG");

                            j.IndexerProperty<string>("CardId").HasMaxLength(36).IsUnicode(false).HasColumnName("CardID");

                            j.IndexerProperty<string>("FinishName").HasMaxLength(8).IsUnicode(false);
                        });
            });

            modelBuilder.Entity<CardUrl>(entity =>
            {
                entity.HasKey(e => e.CardId)
                    .HasName("PK__CardURLs__55FECD8E44FD28DB");

                entity.ToTable("CardURLs", "MtG");

                entity.Property(e => e.CardId)
                    .HasMaxLength(36)
                    .IsUnicode(false)
                    .HasColumnName("CardID");

                entity.Property(e => e.Edhrec)
                    .HasMaxLength(250)
                    .IsUnicode(false)
                    .HasColumnName("EDHRec");

                entity.Property(e => e.Gatherer)
                    .HasMaxLength(250)
                    .IsUnicode(false);

                entity.Property(e => e.Scryfall)
                    .HasMaxLength(250)
                    .IsUnicode(false);

                entity.HasOne(d => d.Card)
                    .WithOne(p => p.CardUrl)
                    .HasForeignKey<CardUrl>(d => d.CardId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_CardUrls");
            });

            modelBuilder.Entity<Collection>(entity =>
            {
                entity.HasKey(e => new { e.CompendiumId, e.CardId, e.Condition, e.StorageLocation })
                    .HasName("CPK_UserCollection");

                entity.ToTable("Collection", "User");

                entity.Property(e => e.CompendiumId)
                    .HasMaxLength(450)
                    .IsUnicode(false)
                    .HasColumnName("CompendiumID");

                entity.Property(e => e.CardId)
                    .HasMaxLength(36)
                    .IsUnicode(false)
                    .HasColumnName("CardID");

                entity.Property(e => e.Condition)
                    .HasMaxLength(12)
                    .IsUnicode(false)
                    .HasDefaultValueSql("('UO-UKN')");

                entity.Property(e => e.StorageLocation)
                    .HasMaxLength(250)
                    .IsUnicode(false)
                    .HasDefaultValueSql("('Undefined')");

                entity.Property(e => e.Quantity).HasDefaultValueSql("((1))");

                entity.HasOne(d => d.Card)
                    .WithMany(p => p.Collections)
                    .HasForeignKey(d => d.CardId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Collectio__CardI__7D4E87B5");

                entity.HasOne(d => d.Compendium)
                    .WithMany(p => p.Collections)
                    .HasPrincipalKey(p => p.CompendiumId)
                    .HasForeignKey(d => d.CompendiumId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Collectio__Compe__7C5A637C");

                entity.HasOne(d => d.ConditionNavigation)
                    .WithMany(p => p.Collections)
                    .HasForeignKey(d => d.Condition)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Collectio__Condi__7E42ABEE");
            });

            modelBuilder.Entity<Color>(entity =>
            {
                entity.HasKey(e => new { e.CardId, e.FaceName, e.ColorId })
                    .HasName("CPK_CardColorID");

                entity.ToTable("Colors", "MtG");

                entity.Property(e => e.CardId)
                    .HasMaxLength(36)
                    .IsUnicode(false)
                    .HasColumnName("CardID");

                entity.Property(e => e.FaceName)
                    .HasMaxLength(141)
                    .IsUnicode(false);

                entity.Property(e => e.ColorId)
                    .HasMaxLength(1)
                    .IsUnicode(false)
                    .HasColumnName("ColorID")
                    .IsFixedLength();

                entity.HasOne(d => d.Card)
                    .WithMany(p => p.Colors)
                    .HasForeignKey(d => d.CardId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Colors__CardID__0AA882D3");

                entity.HasOne(d => d.ColorNavigation)
                    .WithMany(p => p.Colors)
                    .HasForeignKey(d => d.ColorId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Colors__ColorID__0C90CB45");

                entity.HasOne(d => d.FaceNameNavigation)
                    .WithMany(p => p.ColorFaceNameNavigations)
                    .HasPrincipalKey(p => p.FaceName)
                    .HasForeignKey(d => d.FaceName)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Colors__FaceName__0B9CA70C");

                entity.HasOne(d => d.Face)
                    .WithMany(p => p.ColorFaces)
                    .HasForeignKey(d => new { d.CardId, d.FaceName })
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("CFK_FaceID");
            });

            modelBuilder.Entity<Compendium>(entity =>
            {
                entity.HasKey(e => new { e.Id, e.CardName })
                    .HasName("CPK_UserCompendium");

                entity.ToTable("Compendium", "User");

                entity.Property(e => e.Id)
                    .HasMaxLength(450)
                    .IsUnicode(false)
                    .HasColumnName("ID");

                entity.Property(e => e.CardName)
                    .HasMaxLength(141)
                    .IsUnicode(false);

                entity.Property(e => e.TotalQty).HasComputedColumnSql("([MtG].[GetCardTotal]([ID],[CardName]))", false);

                entity.HasOne(d => d.CardNameNavigation)
                    .WithMany(p => p.Compendia)
                    .HasPrincipalKey(p => p.Name)
                    .HasForeignKey(d => d.CardName)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Compendiu__CardN__797DF6D1");

                entity.HasOne(d => d.IdNavigation)
                    .WithMany(p => p.Compendia)
                    .HasPrincipalKey(p => p.CompendiumId)
                    .HasForeignKey(d => d.Id)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Compendium__ID__7889D298");
            });

            modelBuilder.Entity<Detail>(entity =>
            {
                entity.HasKey(e => e.AccountId)
                    .HasName("PK__Details__349DA586CD03A8E6");

                entity.ToTable("Details", "User");

                entity.HasIndex(e => e.AccessId, "UQ__Details__4130D0BE422F8536")
                    .IsUnique();

                entity.HasIndex(e => e.CompendiumId, "UQ__Details__B86CD9DDC6B5E248")
                    .IsUnique();

                entity.Property(e => e.AccountId).HasColumnName("AccountID");

                entity.Property(e => e.AccessId)
                    .HasMaxLength(45)
                    .IsUnicode(false)
                    .HasColumnName("AccessID");

                entity.Property(e => e.CompendiumId)
                    .HasMaxLength(450)
                    .IsUnicode(false)
                    .HasColumnName("CompendiumID");

                entity.HasOne(d => d.Account)
                    .WithOne(p => p.Detail)
                    .HasForeignKey<Detail>(d => d.AccountId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_DetailsAccountID");
            });

            modelBuilder.Entity<Face>(entity =>
            {
                entity.HasKey(e => new { e.CardId, e.FaceName })
                    .HasName("CPK_FaceID");

                entity.ToTable("Face", "MtG");

                entity.HasIndex(e => e.FaceName, "UQ__Face__6E490A5A0262A731")
                    .IsUnique();

                entity.Property(e => e.CardId)
                    .HasMaxLength(36)
                    .IsUnicode(false)
                    .HasColumnName("CardID");

                entity.Property(e => e.FaceName)
                    .HasMaxLength(141)
                    .IsUnicode(false);

                entity.Property(e => e.FlavorText)
                    .HasMaxLength(500)
                    .IsUnicode(false);

                entity.Property(e => e.ManaCost)
                    .HasMaxLength(125)
                    .IsUnicode(false);

                entity.Property(e => e.OracleText)
                    .HasMaxLength(500)
                    .IsUnicode(false);

                entity.Property(e => e.TypeLine)
                    .HasMaxLength(150)
                    .IsUnicode(false);

                entity.HasOne(d => d.Card)
                    .WithMany(p => p.Faces)
                    .HasForeignKey(d => d.CardId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Face__CardID__6F00685E");
            });

            modelBuilder.Entity<ImageUrl>(entity =>
            {
                entity.HasKey(e => new { e.CardId, e.FaceName })
                    .HasName("CPK_FaceImageID");

                entity.ToTable("ImageURLs", "MtG");

                entity.Property(e => e.CardId)
                    .HasMaxLength(36)
                    .IsUnicode(false)
                    .HasColumnName("CardID");

                entity.Property(e => e.FaceName)
                    .HasMaxLength(141)
                    .IsUnicode(false);

                entity.Property(e => e.ArtCrop)
                    .HasMaxLength(250)
                    .IsUnicode(false);

                entity.Property(e => e.BorderCrop)
                    .HasMaxLength(250)
                    .IsUnicode(false);

                entity.Property(e => e.Large)
                    .HasMaxLength(250)
                    .IsUnicode(false);

                entity.Property(e => e.Normal)
                    .HasMaxLength(250)
                    .IsUnicode(false);

                entity.Property(e => e.Png)
                    .HasMaxLength(250)
                    .IsUnicode(false)
                    .HasColumnName("PNG");

                entity.Property(e => e.Small)
                    .HasMaxLength(250)
                    .IsUnicode(false);

                entity.HasOne(d => d.Card)
                    .WithMany(p => p.ImageUrls)
                    .HasForeignKey(d => d.CardId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__ImageURLs__CardI__19EAC663");

                entity.HasOne(d => d.FaceNameNavigation)
                    .WithMany(p => p.ImageUrls)
                    .HasPrincipalKey(p => p.FaceName)
                    .HasForeignKey(d => d.FaceName)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__ImageURLs__FaceN__1ADEEA9C");
            });

            modelBuilder.Entity<Keyword>(entity =>
            {
                entity.HasKey(e => new { e.CardId, e.FaceName, e.Keyword1 })
                    .HasName("CPK_KeywordID");

                entity.ToTable("Keywords", "MtG");

                entity.Property(e => e.CardId)
                    .HasMaxLength(36)
                    .IsUnicode(false)
                    .HasColumnName("CardID");

                entity.Property(e => e.FaceName)
                    .HasMaxLength(141)
                    .IsUnicode(false);

                entity.Property(e => e.Keyword1)
                    .HasMaxLength(25)
                    .IsUnicode(false)
                    .HasColumnName("Keyword");

                entity.HasOne(d => d.Card)
                    .WithMany(p => p.Keywords)
                    .HasForeignKey(d => d.CardId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Keywords__CardID__1249A49B");

                entity.HasOne(d => d.FaceNameNavigation)
                    .WithMany(p => p.Keywords)
                    .HasPrincipalKey(p => p.FaceName)
                    .HasForeignKey(d => d.FaceName)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Keywords__FaceNa__133DC8D4");

                entity.HasOne(d => d.Keyword1Navigation)
                    .WithMany(p => p.Keywords)
                    .HasForeignKey(d => d.Keyword1)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Keywords__Keywor__1431ED0D");
            });

            modelBuilder.Entity<Legality>(entity =>
            {
                entity.HasKey(e => e.CardId)
                    .HasName("PK__Legaliti__55FECD8E73905F92");

                entity.ToTable("Legalities", "MtG");

                entity.Property(e => e.CardId)
                    .HasMaxLength(36)
                    .IsUnicode(false)
                    .HasColumnName("CardID");

                entity.Property(e => e.Alchemy)
                    .HasMaxLength(1)
                    .HasDefaultValueSql("('N')")
                    .IsFixedLength();

                entity.Property(e => e.Brawl)
                    .HasMaxLength(1)
                    .HasDefaultValueSql("('N')")
                    .IsFixedLength();

                entity.Property(e => e.Commander)
                    .HasMaxLength(1)
                    .HasDefaultValueSql("('N')")
                    .IsFixedLength();

                entity.Property(e => e.Duel)
                    .HasMaxLength(1)
                    .HasDefaultValueSql("('N')")
                    .IsFixedLength();

                entity.Property(e => e.Explorer)
                    .HasMaxLength(1)
                    .HasDefaultValueSql("('N')")
                    .IsFixedLength();

                entity.Property(e => e.Future)
                    .HasMaxLength(1)
                    .HasDefaultValueSql("('N')")
                    .IsFixedLength();

                entity.Property(e => e.Gladiator)
                    .HasMaxLength(1)
                    .HasDefaultValueSql("('N')")
                    .IsFixedLength();

                entity.Property(e => e.Historic)
                    .HasMaxLength(1)
                    .HasDefaultValueSql("('N')")
                    .IsFixedLength();

                entity.Property(e => e.HistoricBrawl)
                    .HasMaxLength(1)
                    .HasDefaultValueSql("('N')")
                    .IsFixedLength();

                entity.Property(e => e.Legacy)
                    .HasMaxLength(1)
                    .HasDefaultValueSql("('N')")
                    .IsFixedLength();

                entity.Property(e => e.Modern)
                    .HasMaxLength(1)
                    .HasDefaultValueSql("('N')")
                    .IsFixedLength();

                entity.Property(e => e.Oathbreaker)
                    .HasMaxLength(1)
                    .HasDefaultValueSql("('N')")
                    .IsFixedLength();

                entity.Property(e => e.Oldschool)
                    .HasMaxLength(1)
                    .HasDefaultValueSql("('N')")
                    .IsFixedLength();

                entity.Property(e => e.Pauper)
                    .HasMaxLength(1)
                    .HasDefaultValueSql("('N')")
                    .IsFixedLength();

                entity.Property(e => e.PauperCommander)
                    .HasMaxLength(1)
                    .HasDefaultValueSql("('N')")
                    .IsFixedLength();

                entity.Property(e => e.Penny)
                    .HasMaxLength(1)
                    .HasDefaultValueSql("('N')")
                    .IsFixedLength();

                entity.Property(e => e.Pioneer)
                    .HasMaxLength(1)
                    .HasDefaultValueSql("('N')")
                    .IsFixedLength();

                entity.Property(e => e.Predh)
                    .HasMaxLength(1)
                    .HasDefaultValueSql("('N')")
                    .IsFixedLength();

                entity.Property(e => e.Premodern)
                    .HasMaxLength(1)
                    .HasDefaultValueSql("('N')")
                    .IsFixedLength();

                entity.Property(e => e.Standard)
                    .HasMaxLength(1)
                    .HasDefaultValueSql("('N')")
                    .IsFixedLength();

                entity.Property(e => e.Vintage)
                    .HasMaxLength(1)
                    .HasDefaultValueSql("('N')")
                    .IsFixedLength();

                entity.HasOne(d => d.Card)
                    .WithOne(p => p.Legality)
                    .HasForeignKey<Legality>(d => d.CardId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_CardLegalities");
            });

            modelBuilder.Entity<Price>(entity =>
            {
                entity.HasKey(e => e.CardId)
                    .HasName("PK__Prices__55FECD8EF30B7B34");

                entity.ToTable("Prices", "MtG");

                entity.Property(e => e.CardId)
                    .HasMaxLength(36)
                    .IsUnicode(false)
                    .HasColumnName("CardID");

                entity.Property(e => e.Eur)
                    .HasColumnType("decimal(10, 2)")
                    .HasColumnName("EUR");

                entity.Property(e => e.EurFoil)
                    .HasColumnType("decimal(10, 2)")
                    .HasColumnName("EUR_Foil");

                entity.Property(e => e.Tix)
                    .HasColumnType("decimal(10, 2)")
                    .HasColumnName("TIX");

                entity.Property(e => e.Usd)
                    .HasColumnType("decimal(10, 2)")
                    .HasColumnName("USD");

                entity.Property(e => e.UsdEtched)
                    .HasColumnType("decimal(10, 2)")
                    .HasColumnName("USD_Etched");

                entity.Property(e => e.UsdFoil)
                    .HasColumnType("decimal(10, 2)")
                    .HasColumnName("USD_Foil");

                entity.HasOne(d => d.Card)
                    .WithOne(p => p.Price)
                    .HasForeignKey<Price>(d => d.CardId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_CardPrices");
            });

            modelBuilder.Entity<PurchaseUrl>(entity =>
            {
                entity.HasKey(e => e.CardId)
                    .HasName("PK__Purchase__55FECD8ED1EC513B");

                entity.ToTable("PurchaseURLs", "MtG");

                entity.Property(e => e.CardId)
                    .HasMaxLength(36)
                    .IsUnicode(false)
                    .HasColumnName("CardID");

                entity.Property(e => e.CardHoarder)
                    .HasMaxLength(250)
                    .IsUnicode(false);

                entity.Property(e => e.CardMarket)
                    .HasMaxLength(250)
                    .IsUnicode(false);

                entity.Property(e => e.Tcgplayer)
                    .HasMaxLength(250)
                    .IsUnicode(false)
                    .HasColumnName("TCGPlayer");

                entity.HasOne(d => d.Card)
                    .WithOne(p => p.PurchaseUrl)
                    .HasForeignKey<PurchaseUrl>(d => d.CardId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_CardPurchaseUrls");
            });

            modelBuilder.HasSequence<int>("sqCounter", "Admin").StartsAt(0);

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
