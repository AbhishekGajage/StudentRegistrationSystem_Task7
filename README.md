# Student Registration System

An ASP.NET Web Forms (C#) application for managing student registrations, with a
student-facing portal and an admin approval workflow.

---

## Features

**Student Portal**
- Registration with full profile capture: name, email, mobile number (used as
  login password), country/state/district (cascading dropdowns), address,
  gender, date of birth, and an optional profile photo (JPG/JPEG/PNG, max 2 MB).
- CAPTCHA-protected login using email + 10-digit mobile number.
- Student dashboard to view profile details, edit profile info, and change
  password (by updating mobile number).

**Admin Portal**
- Separate Admin Login, independent from the student login.
- Admin dashboard with live stats: total / active / inactive students, and
  pending / approved / rejected applications.
- Manage Candidates grid with filtering by approval status and account status,
  and a compact per-row actions menu (⋮) to:
  - Approve / Reject (with mandatory rejection remark) / Reset an application
  - Activate / Deactivate a student's account

**Access control**
- New registrations default to **Pending** approval status; only
  **Approved + Active** students can log in.
- Rejected applications record a remark, visible to admins in the grid.

---

## Tech Stack

- ASP.NET Web Forms, C#
- SQL Server (SSMS)
- jQuery, intl-tel-input (mobile number input)

---

## Getting Started

1. **Database setup**
   Run `Admin_Schema.sql` in SSMS as a full script execution (F5), not in
   partial highlighted chunks — the `GO` batch separators must run in order.
   This creates the `Admins` table and adds required columns
   (e.g. `CreatedDate`) to existing tables.

2. **Web.config**
   Verify the connection string points at your local SQL Server instance
   before building.

3. **Build & run**
   Open the solution in Visual Studio, build, and run. The student login is
   at `Login.aspx`; the admin login is linked from there via
   **Admin Login →**, and lives at `AdminLogin.aspx`.

---

## Default Admin Credentials

> ⚠️ **TODO:** Fill in the actual seeded values from your `Admin_Schema.sql`
> `INSERT INTO Admins (...)` statement. Paste that statement to me if you'd
> like me to fill this in for you automatically.

| Field    | Value                           |
|----------|---------------------------------|
| Username | admin                           |
| Password | Admin@123                       |

**Change this password immediately after your first login** — this was the
final step of the project's test checklist and should not be left as the
default in a real deployment.

---

## Testing Checklist (summary)

1. Register a new student → status defaults to **Pending**
2. Attempt login while Pending → blocked
3. Admin approves the application → status becomes **Approved**
4. Student can now log in
5. Admin rejects a (different) application with a remark → status **Rejected**,
   remark visible in Manage Candidates
6. Admin resets a Rejected application back to **Pending**
7. Admin deactivates an Active account → student login blocked
8. Admin reactivates the account → student login restored
9. Student edits their profile (name, address, mobile/password, photo)
10. Student changes password by updating mobile number, logs in with new one
11. Admin logs out and back in via Admin Login
12. Admin changes the seeded default admin password

---

## Project Structure (key pages)

| Page                  | Purpose                                   |
|------------------------|--------------------------------------------|
| `Login.aspx`           | Student login (email + mobile, CAPTCHA)   |
| `Register.aspx`        | Student registration                      |
| `Dashboard.aspx`       | Student profile view/edit                 |
| `AdminLogin.aspx`      | Admin login                               |
| `AdminDashboard.aspx`  | Admin stats + quick actions               |
| `ManageCandidates.aspx`| Approve/reject/activate/deactivate grid   |
