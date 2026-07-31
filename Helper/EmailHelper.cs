using System;
using System.Configuration;
using System.IO;
using System.Net;
using System.Net.Mail;
using System.Web;

/// <summary>
/// Sends templated HTML emails: OTP verification to the student,
/// new-registration notifications to the admin, and application
/// approval/rejection notifications to the student.
/// </summary>
public static class EmailHelper
{
    private const string InstituteName = "new institude";

    private static SmtpClient BuildSmtpClient()
    {
        var host = ConfigurationManager.AppSettings["SmtpHost"];
        var port = int.Parse(ConfigurationManager.AppSettings["SmtpPort"]);
        var enableSsl = bool.Parse(ConfigurationManager.AppSettings["SmtpEnableSsl"]);
        var username = ConfigurationManager.AppSettings["SmtpUsername"];
        var password = ConfigurationManager.AppSettings["SmtpPassword"];

        return new SmtpClient(host, port)
        {
            EnableSsl = enableSsl,
            Credentials = new NetworkCredential(username, password)
        };
    }

    private static string LoadTemplate(string fileName)
    {
        string path = HttpContext.Current.Server.MapPath("~/EmailTemplates/" + fileName);
        return File.ReadAllText(path);
    }

    /// <summary>Sends the OTP verification email to the student.</summary>
    public static void SendOtpEmail(string toEmail, string studentName, string otpCode)
    {
        string body = LoadTemplate("OtpEmailTemplate.html");
        body = body.Replace("{{InstituteName}}", InstituteName)
                    .Replace("{{StudentName}}", string.IsNullOrWhiteSpace(studentName) ? "Student" : studentName)
                    .Replace("{{OtpCode}}", otpCode)
                    .Replace("{{ExpiryMinutes}}", ConfigurationManager.AppSettings["OtpExpiryMinutes"])
                    .Replace("{{CurrentYear}}", DateTime.Now.Year.ToString());

        SendMail(toEmail, "Your OTP Code for Student Registration", body);
    }

    /// <summary>Sends a "new student registered" notification to the admin.</summary>
    public static void SendAdminNotification(string studentId, string studentName, string email,
        string mobile, string country, string state, string district, DateTime registeredAt)
    {
        string body = LoadTemplate("AdminNotificationTemplate.html");
        body = body.Replace("{{InstituteName}}", InstituteName)
                    .Replace("{{StudentID}}", studentId)
                    .Replace("{{StudentName}}", studentName)
                    .Replace("{{Email}}", email)
                    .Replace("{{Mobile}}", mobile)
                    .Replace("{{Country}}", country)
                    .Replace("{{State}}", state)
                    .Replace("{{District}}", district)
                    .Replace("{{RegistrationDateTime}}", registeredAt.ToString("dd-MMM-yyyy hh:mm tt"));

        string adminEmail = ConfigurationManager.AppSettings["AdminEmail"];
        SendMail(adminEmail, "New Student Registration: " + studentName, body);
    }

    /// <summary>Task 7: notifies the student their application was approved.</summary>
    public static void SendApprovalEmail(string toEmail, string studentName, string studentId)
    {
        string body = LoadTemplate("ApprovalEmailTemplate.html");
        body = body.Replace("{{InstituteName}}", InstituteName)
                    .Replace("{{StudentName}}", string.IsNullOrWhiteSpace(studentName) ? "Student" : studentName)
                    .Replace("{{StudentID}}", studentId)
                    .Replace("{{ApprovalDateTime}}", DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt"))
                    .Replace("{{CurrentYear}}", DateTime.Now.Year.ToString());

        SendMail(toEmail, "Your Registration Has Been Approved", body);
    }

    /// <summary>Task 7: notifies the student their application was rejected, with the remark.</summary>
    public static void SendRejectionEmail(string toEmail, string studentName, string studentId, string remark)
    {
        string body = LoadTemplate("RejectionEmailTemplate.html");
        body = body.Replace("{{InstituteName}}", InstituteName)
                    .Replace("{{StudentName}}", string.IsNullOrWhiteSpace(studentName) ? "Student" : studentName)
                    .Replace("{{StudentID}}", studentId)
                    .Replace("{{RejectionRemark}}", HttpUtility.HtmlEncode(remark))
                    .Replace("{{RejectionDateTime}}", DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt"))
                    .Replace("{{CurrentYear}}", DateTime.Now.Year.ToString());

        SendMail(toEmail, "Update on Your Registration Application", body);
    }

    private static void SendMail(string toEmail, string subject, string htmlBody)
    {
        using (MailMessage mail = new MailMessage())
        {
            mail.From = new MailAddress(
                ConfigurationManager.AppSettings["FromEmail"],
                ConfigurationManager.AppSettings["FromDisplayName"]);
            mail.To.Add(toEmail);
            mail.Subject = subject;
            mail.Body = htmlBody;
            mail.IsBodyHtml = true;

            using (SmtpClient client = BuildSmtpClient())
            {
                client.Send(mail);
            }
        }
    }
}
