using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace MtG_UCC.Data
{
    public class ApplicationDbContext : IdentityDbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
            : base(options)
        {
        }
        protected override void OnModelCreating(ModelBuilder builder)
        {
            base.OnModelCreating(builder);
            builder.Entity<IdentityUser>().ToTable("AspNetUsers", "Admin");
            builder.Entity<IdentityRole>().ToTable("AspNetRoles", "Admin");
            builder.Entity<IdentityUserClaim<string>>().ToTable("AspNetUserClaims", "Admin");
            builder.Entity<IdentityUserRole<string>>().ToTable("AspNetUserRoles", "Admin");
            builder.Entity<IdentityUserLogin<string>>().ToTable("AspNetUserLogins", "Admin");
            builder.Entity<IdentityRoleClaim<string>>().ToTable("AspNetRoleClaims", "Admin");
            builder.Entity<IdentityUserToken<string>>().ToTable("AspNetUserTokens", "Admin");
        }
    }
}