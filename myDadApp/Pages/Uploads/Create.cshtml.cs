using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc.Rendering;
using myDadApp.Data;
using myDadApp.Models;

namespace myDadApp.Pages.Uploads
{
    [Authorize]
    public class CreateModel : PageModel
    {
        private readonly myDadApp.Data.ApplicationDbContext _context;

        public CreateModel(myDadApp.Data.ApplicationDbContext context)
        {
            _context = context;
        }

        public IActionResult OnGet()
        {
            return Page();
        }

        [BindProperty]
        public Upload Upload { get; set; } = default!;

        // To protect from overposting attacks, see https://aka.ms/RazorPagesCRUD
        public async Task<IActionResult> OnPostAsync()
        {
            if (!ModelState.IsValid)
            {
                return Page();
            }

            _context.Upload.Add(Upload);
            await _context.SaveChangesAsync();

            return RedirectToPage("./Index");
        }
    }
}
