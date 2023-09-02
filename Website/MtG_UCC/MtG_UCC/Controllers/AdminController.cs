using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MtG_UCC.Data;
using MtG_UCC.Models.Database;
using System.Diagnostics;
using static MtG_UCC.Services.GlobalMethods;

namespace MtG_UCC.Controllers {
    public class AdminController : Controller {
        private readonly UserManager<IdentityUser> users;
        private readonly RoleManager<IdentityRole> roles;
        public AdminController(UserManager<IdentityUser> _users, RoleManager<IdentityRole> _roles) {
            users = _users;
            roles = _roles;
        }

        [Authorize(Roles = "Administrator,Owner")]
        public async Task<IActionResult> UserManagement() {
            List<UsersWithRoles> usersWithRoles = new();

            usersWithRoles = await GetAllUsersAndRoles(users, User);

            ViewData["RolesList"] = await roles.Roles.ToListAsync();

            return View(usersWithRoles);
        }

        [HttpPost, Authorize(Roles = "Administrator,Owner")]
        public async Task<IActionResult> EditRole(string UserId, string RoleId) {
            Debug.WriteLine($"ROLE ID ::: {RoleId}"); Console.WriteLine($"ROLE ID ::: {RoleId}");
            if (await UpdateUserRole(users, User, UserId, RoleId)) {
                return RedirectToAction("UserManagement");
            } else {
                return BadRequest($"{UserId} {RoleId}");
            }
        }

        [Authorize(Roles = "Administrator,Owner")]
        public async Task<IActionResult> UserStatistics() { 
            List<CardStat> top25 = await RetrieveTop25(users, User);

            return View(top25);
        }

        //public async Task<IActionResult> DeleteUser(string UserId) { 
        
        //}

    }
}
