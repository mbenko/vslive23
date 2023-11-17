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
    public class IndexModel : PageModel
    {
        private readonly myDadApp.Data.ApplicationDbContext _context;

        public IndexModel(myDadApp.Data.ApplicationDbContext context)
        {
            _context = context;
        }

        public IList<Upload> Upload { get;set; } = default!;

        public async Task OnGetAsync()
        {
            Upload = await _context.Upload.ToListAsync();
        }
    }
}
