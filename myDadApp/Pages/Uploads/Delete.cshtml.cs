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
    public class DeleteModel : PageModel
    {
        private readonly myDadApp.Data.ApplicationDbContext _context;

        public DeleteModel(myDadApp.Data.ApplicationDbContext context)
        {
            _context = context;
        }

        [BindProperty]
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

        public async Task<IActionResult> OnPostAsync(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var upload = await _context.Upload.FindAsync(id);
            if (upload != null)
            {
                Upload = upload;
                _context.Upload.Remove(Upload);
                await _context.SaveChangesAsync();
            }

            return RedirectToPage("./Index");
        }
    }
}
