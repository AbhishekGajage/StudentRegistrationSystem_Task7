using System;
using System.Data;
using System.IO;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class StudentList : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindStudentGrid();
        }
    }

    private DataTable GetAllStudents()
    {
        return DBHelper.ExecuteQuery(
            @"SELECT s.StudentID, s.FullName, s.Email, s.MobileNumber,
                 c.CountryName, s.StateName, s.DistrictName,
                 s.Course, s.Semester, s.RegistrationDate, s.ProfilePhotoPath
          FROM Students s
          INNER JOIN Countries c ON s.CountryID = c.CountryID
          ORDER BY s.RegistrationDate DESC");
    }

    private void BindStudentGrid()
    {
        DataTable dt = GetAllStudents();
        gvStudents.DataSource = dt;
        gvStudents.DataBind();
        lblTotalCount.Text = dt.Rows.Count + " student record(s) found";
    }

    protected void btnRefresh_Click(object sender, EventArgs e)
    {
        BindStudentGrid();
    }

    /// <summary>
    /// Exports all student records to an Excel-compatible .xls file.
    /// Uses a lightweight HTML-table-with-Excel-mimetype approach so no
    /// external NuGet package (EPPlus/ClosedXML) is required to run this
    /// out of the box. Swap in EPPlus for true .xlsx if you have it installed.
    /// </summary>
    protected void btnExportExcel_Click(object sender, EventArgs e)
    {
        DataTable dt = GetAllStudents();

        Response.Clear();
        Response.Buffer = true;
        Response.AddHeader("content-disposition",
            "attachment;filename=StudentRecords_" + DateTime.Now.ToString("yyyyMMdd_HHmmss") + ".xls");
        Response.Charset = "";
        Response.ContentType = "application/vnd.ms-excel";

        StringBuilder sb = new StringBuilder();

        // Basic styling so the exported sheet looks presentable in Excel.
        sb.Append("<html><head><style>");
        sb.Append("table { border-collapse: collapse; font-family: Arial, sans-serif; font-size: 11pt; }");
        sb.Append("th { background:#2b5fd9; color:#fff; padding:6px 10px; border:1px solid #999; text-align:left; }");
        sb.Append("td { padding:5px 10px; border:1px solid #ccc; }");
        sb.Append("</style></head><body>");
        sb.Append("<table>");

        // Header row
        sb.Append("<tr>");
        string[] headers = {
            "Student ID", "Full Name", "Email", "Mobile Number", "Country",
            "State", "District", "Course", "Semester", "Registration Date"
        };
        foreach (string h in headers) sb.Append("<th>" + h + "</th>");
        sb.Append("</tr>");

        // Data rows
        foreach (DataRow row in dt.Rows)
        {
            sb.Append("<tr>");
            sb.Append("<td>" + row["StudentID"] + "</td>");
            sb.Append("<td>" + row["FullName"] + "</td>");
            sb.Append("<td>" + row["Email"] + "</td>");
            sb.Append("<td>" + row["MobileNumber"] + "</td>");
            sb.Append("<td>" + row["CountryName"] + "</td>");
            sb.Append("<td>" + row["StateName"] + "</td>");
            sb.Append("<td>" + row["DistrictName"] + "</td>");
            sb.Append("<td>" + row["Course"] + "</td>");
            sb.Append("<td>" + row["Semester"] + "</td>");
            sb.Append("<td>" + Convert.ToDateTime(row["RegistrationDate"]).ToString("dd-MMM-yyyy hh:mm tt") + "</td>");
            sb.Append("</tr>");
        }

        sb.Append("</table></body></html>");

        Response.Output.Write(sb.ToString());
        Response.Flush();
        Response.End();
    }
}
