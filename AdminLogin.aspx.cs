using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

public partial class AdminLogin : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Already logged in? Skip straight to the dashboard.
        if (!IsPostBack && Session["AdminID"] != null)
        {
            Response.Redirect("AdminDashboard.aspx");
        }
    }

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        string username = txtUsername.Text.Trim();
        string password = txtPassword.Text;
        string hashedPassword = AdminAuthHelper.HashPassword(password);

        DataTable dt = DBHelper.ExecuteQuery(
            "SELECT AdminID, Username, FullName FROM Admins WHERE Username = @Username AND PasswordHash = @PasswordHash",
            new SqlParameter("@Username", username),
            new SqlParameter("@PasswordHash", hashedPassword));

        if (dt.Rows.Count == 0)
        {
            lblError.Text = "Invalid username or password.";
            lblError.Visible = true;
            return;
        }

        DataRow row = dt.Rows[0];
        Session["AdminID"] = row["AdminID"];
        Session["AdminUsername"] = row["Username"].ToString();
        Session["AdminFullName"] = row["FullName"].ToString();

        Response.Redirect("AdminDashboard.aspx");
    }
}
