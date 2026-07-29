<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StudentList.aspx.cs" Inherits="StudentList" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Registered Students</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="stylesheet" href="Styles/Site.css" />
    <link rel="stylesheet" media="print" href="Styles/Print.css" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="page-wrapper">
            <div class="top-bar no-print">
                <h1>Registered Students</h1>
                <p>All students who have completed OTP-verified registration.</p>
                <p><a href="Register.aspx" style="color:#fff;">&larr; Back to Registration Form</a></p>
            </div>

            <div class="print-header" style="display:none;">
                <h2>Registered Students</h2>
                <p>Printed on <%= DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt") %></p>
            </div>

            <div class="card">
                <div class="grid-toolbar no-print">
                    <div>
                        <strong><asp:Label ID="lblTotalCount" runat="server"></asp:Label></strong>
                    </div>
                    <div class="btn-row" style="margin:0;">
                        <asp:Button ID="btnPrint" runat="server" Text="Print" CssClass="btn btn-secondary"
                            OnClientClick="printStudentGrid(); return false;" />
                        <asp:Button ID="btnExportExcel" runat="server" Text="Export to Excel"
                            CssClass="btn btn-success" OnClick="btnExportExcel_Click" />
                        <asp:Button ID="btnRefresh" runat="server" Text="Refresh" CssClass="btn btn-outline"
                            OnClick="btnRefresh_Click" />
                    </div>
                </div>

                <div class="table-scroll">
                    <asp:GridView ID="gvStudents" runat="server" CssClass="student-grid"
                        AutoGenerateColumns="false" GridLines="None" EmptyDataText="No student records found.">
                        <Columns>
                            <asp:TemplateField HeaderText="Photo">
                                <ItemTemplate>
                                    <img class="grid-photo" src='<%# ResolveUrl(Eval("ProfilePhotoPath").ToString()) %>' alt="Photo" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="StudentID" HeaderText="Student ID" />
                            <asp:BoundField DataField="FullName" HeaderText="Name" />
                            <asp:BoundField DataField="Email" HeaderText="Email" />
                            <asp:BoundField DataField="MobileNumber" HeaderText="Mobile" />
                            <asp:BoundField DataField="CountryName" HeaderText="Country" />
                            <asp:BoundField DataField="StateName" HeaderText="State" />
                            <asp:BoundField DataField="DistrictName" HeaderText="District" />
                            <asp:BoundField DataField="Course" HeaderText="Course" />
                            <asp:BoundField DataField="Semester" HeaderText="Semester" />
                            <asp:BoundField DataField="RegistrationDate" HeaderText="Registered On"
                                DataFormatString="{0:dd-MMM-yyyy hh:mm tt}" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </form>

    <script src="Scripts/site.js"></script>
    <script>
        // Show the print-only header, hide the screen-only chrome, right before printing.
        window.addEventListener('beforeprint', function () {
            document.querySelector('.print-header').style.display = 'block';
        });
        window.addEventListener('afterprint', function () {
            document.querySelector('.print-header').style.display = 'none';
        });
    </script>
</body>
</html>
