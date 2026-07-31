<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminLogin.aspx.cs" Inherits="AdminLogin" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Admin Login</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="stylesheet" href="Styles/Site.css" />
    <link rel="stylesheet" href="Styles/Auth.css" />
    <style>
        .auth-icon {
            display: inline-block;
            padding: 6px 16px;
            border-radius: 999px;
            background: #eef2ff;
            color: #4338ca;
            font-size: 11.5px;
            font-weight: 700;
            letter-spacing: .05em;
            text-transform: uppercase;
            margin-bottom: 14px;
        }
        

        /* ---- Footer ---- */
        .auth-footer { text-align: center; margin-top: 22px; }
        .auth-footer p { margin: 6px 0; font-size: 13.5px; color: #6b7280; }
        .auth-footer a { color: #4338ca; font-weight: 600; text-decoration: none; }
        .auth-footer a:hover { text-decoration: underline; }

        /* Back-to-student-login is an asp:Button under the hood (needs the
           postback-free OnClientClick redirect), styled to read as a footer link. */
        .footer-link-btn {
            background: none;
            border: none;
            padding: 0;
            margin: 0;
            font: inherit;
            font-size: 13.5px;
            font-weight: 600;
            color: #4338ca;
            cursor: pointer;
        }
        .footer-link-btn:hover { text-decoration: underline; }
    </style>
</head>
<body class="auth-body">
    <form id="form1" runat="server">
        <div class="auth-wrapper">
            <div class="auth-card">
                <div class="auth-header">
                    <div class="auth-icon">New Institute</div>
                    <h1>Admin Login</h1>
                    <p>Student Registration System &mdash; Administration.</p>
                </div>

                <div class="auth-body-form">
                    <asp:Label ID="lblError" runat="server" CssClass="status-message status-error" Visible="false"></asp:Label>

                    <div class="form-group">
                        <label>Username<span class="required">*</span></label>
                        <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Enter your admin username"></asp:TextBox>
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtUsername"
                            CssClass="field-error" Display="Dynamic" ErrorMessage="Username is required." ValidationGroup="AdminLoginGroup" />
                    </div>

                    <div class="form-group">
                        <label>Password<span class="required">*</span></label>
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Enter your password"></asp:TextBox>
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPassword"
                            CssClass="field-error" Display="Dynamic" ErrorMessage="Password is required." ValidationGroup="AdminLoginGroup" />
                    </div>

                    <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn btn-primary auth-submit-btn"
                        ValidationGroup="AdminLoginGroup" OnClick="btnLogin_Click" />
                </div>

                <div class="auth-footer">
                    <p>
                        <asp:Button ID="btnBackToLogin" runat="server" Text="&larr; Back to Student Login" CssClass="footer-link-btn"
                            CausesValidation="false" OnClientClick="window.location.href='Login.aspx'; return false;" />
                    </p>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
