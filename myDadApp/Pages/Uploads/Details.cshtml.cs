using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;
using myDadApp.Data;
using myDadApp.Models;

namespace myDadApp.Pages.Uploads
{
    public class DetailsModel : PageModel
    {
        private readonly myDadApp.Data.ApplicationDbContext _context;

        public DetailsModel(myDadApp.Data.ApplicationDbContext context)
        {
            _context = context;
        }

        public Upload Upload { get; set; } = default!;

        public async Task<IActionResult> OnGetAsync(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var upload = await _context.Upload.FirstOrDefaultAsync(m => m.Id == id);
            if (upload == null)
            {
                return NotFound();
            }
            else
            {
                Upload = upload;
            }
            return Page();
        }
    }
}
