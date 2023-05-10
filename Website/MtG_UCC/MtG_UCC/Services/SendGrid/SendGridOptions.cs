namespace MtG_UCC.Services.SendGrid
{
    public class SendGridOptions
    {
        public const string SendGrid = "SendGrid";
        public string ApiKey { get; set; }
        public string FromEmail { get; set; }
        public string FromName { get; set; }
        public string RegisterTemplateID { get; set; }
    }
}
