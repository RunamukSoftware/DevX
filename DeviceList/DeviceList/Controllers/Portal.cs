namespace DeviceList.Controllers
{
    using System;
    using System.Data.Entity;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Linq;

    public partial class Portal : DbContext
    {
        public Portal()
            : base("name=Portal")
        {
        }

        public virtual DbSet<Device> Devices { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Device>()
                .Property(e => e.Name)
                .IsUnicode(false);

            modelBuilder.Entity<Device>()
                .Property(e => e.Description)
                .IsUnicode(false);

            modelBuilder.Entity<Device>()
                .Property(e => e.Room)
                .IsUnicode(false);
        }
    }
}
