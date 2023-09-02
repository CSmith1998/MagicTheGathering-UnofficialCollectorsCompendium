using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using static MtG_UCC_API.ServiceMethods;
using MtG_UCC_API.Models;
using MtG_UCC_API.Models.Database;
using Microsoft.IdentityModel.Tokens;
using System.Diagnostics;
using Azure;

namespace MtG_UCC_API.Controllers {
    [ApiController]
    [Route("[controller]/[action]")]
    public class AdminController : ControllerBase {
        private readonly ILogger<AdminController> _logger;

        public AdminController(ILogger<AdminController> logger) {
            _logger = logger;
        }

        [HttpPut]
        public async Task<string> UpdateUserRole() {
            Dictionary<string, string> headers;

            String Message = "";

            try {
                headers = GetHeaderValues(this.Request.Headers);
                var accountID = GetAccountID(headers);  

                if (await CheckAdminAuthorization(GetAuthToken(headers), accountID)) { 
                    var userAccountID = GetUserAccountID(headers);
                    var roleID = GetRoleID(headers);

                    if(userAccountID != null && roleID != null) {
                        Message = await ChangeUserRole(userAccountID, roleID);
                        Debug.WriteLine($"ERROR : {Message}"); Console.WriteLine($"ERROR : {Message}");
                    } else {
                        Message = new($"A required parameter was not provided!");
                        Debug.WriteLine($"ERROR : {Message}"); Console.WriteLine($"ERROR : {Message}");
                    }

                    if(Message.Equals($"Successfully updated record!")) {
                        Message = new($"{GetUsername(userAccountID)}'s role was updated successfully!");
                        Debug.WriteLine($"ERROR : {Message}"); Console.WriteLine($"ERROR : {Message}");
                    }

                } else Message = new($"Unauthorized access denied!");
                Debug.WriteLine($"ERROR : {Message}"); Console.WriteLine($"ERROR : {Message}");
            } catch(Exception ex) {
                Message = GenerateUnknownError(this.ControllerContext.RouteData, ex);
            }

            return Message;
        }

        [HttpGet]
        public async Task<List<CardStatistic>> UserCardStatistics() { 
            Dictionary<string, string> headers;
            List<CardStatistic> Stats = new();

            try {
                headers = GetHeaderValues(this.Request.Headers);
                var accountID = GetAccountID(headers);

                if (await CheckAdminAuthorization(GetAuthToken(headers), accountID)) {
                    Stats = await GetTop25();
                } else Stats.Add(new($"Unauthorized! Access denied!", 401));

            } catch(Exception ex) {
                Stats.Add(new(GenerateUnknownError(this.ControllerContext.RouteData, ex), 400));
            }

            return Stats;
        }

        [HttpGet]
        public async Task<List<UsersWithRoles>> GetAllUsers() { 
            Dictionary<string, string> headers;

            List<UsersWithRoles> list = new();

            UsersWithRoles error = new();

            try {
                headers = GetHeaderValues(this.Request.Headers);
                var accountID = GetAccountID(headers);

                if (await CheckAdminAuthorization(GetAuthToken(headers), accountID)) { 

                    list = await RetrieveUsersWithRoles();

                } else error.UserId = new($"Unauthorized access denied!");
            } catch(Exception ex) {
                error.UserId = GenerateUnknownError(this.ControllerContext.RouteData, ex);
            }

            if(!error.UserId.IsNullOrEmpty()) {
                list.Add(error);
            }

            return list;
        }

        [HttpDelete("{UserID}")]
        public async Task<string> DeleteUser(String UserID) { 
            Dictionary<string, string> headers;

            String Message = "";

            try {
                headers = GetHeaderValues(this.Request.Headers);
                var accountID = GetAccountID(headers);

                if (await CheckAdminAuthorization(GetAuthToken(headers), accountID)) { 

                    if(UserID != null) {
                        Message = await DeleteUserFromDatabase(UserID);
                    } else {
                        Message = new($"A required parameter was not provided!");
                    }

                    if(Message.Equals($"Successfully deleted record!")) {
                        Message = new($"User was deleted successfully!");
                    }

                } else Message = new($"Unauthorized access denied!");
            } catch(Exception ex) {
                Message = GenerateUnknownError(this.ControllerContext.RouteData, ex);
            }

            return Message;
        }
    }
}
