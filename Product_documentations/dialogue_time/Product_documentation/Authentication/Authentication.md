> # Authentication

To improve security and reduce administrative overhead, Dialogue Time requires SSO for user authentication. Previously, the application used a traditional user management system, storing personal information and hashed passwords in a database, with an infrastructure for password and manual recovery. However, using SSO would provide double authentication and eliminate the risks of password compromise due to SQL injection or breaches, as well as the need for user management in multiple systems.
