using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;

namespace angapp.Controllers
{
    [Route("api/[controller]")]
    public class OtherDataController : Controller
    {
        [HttpGet("[action]")]
        public IEnumerable<RandomNumber> Random()
        {
            var rng = new Random();
            return Enumerable.Range(1, 5).Select(index => new RandomNumber
            {
                Number = rng.Next(1, 100),
            });
        }

        public class RandomNumber
        {
            public int Number { get; set; }
        }
    }
}
