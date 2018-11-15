namespace DeviceList.Controllers
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class Device
    {
        [Key]
        [Column(Order = 0)]
        public Guid Id { get; set; }

        //[Key]
        //[Column(Order = 1)]
        [StringLength(50)]
        public string Name { get; set; }

        [StringLength(50)]
        public string Description { get; set; }

        [StringLength(12)]
        public string Room { get; set; }
    }
}
