> # GDPR

## Steps taken

To comply with GDPR regulations, Dialogue Time has removed personal information about consultants from its database. This approach has its challenges as it can impact the long-term stability of the application due to dependency factors. However, it removes the need for developing GDPR functionalities like periodically removing personal information. All personal information and user authentication are managed through Microsoft MSAL integration to ensure compliance with GDPR regulations.

## Pseudonymization / anonymization:

Storage of personal information used for development, testing or production is avoided by using unique user IDs as an identifier for which third-party software providers are responsible. The data application is for use to carry out the purposes of the person responsible. No procedure for pseudonymization is in place for development or testing.

### Caveat:

Whilst developing an anonymized database structure, using third-party user management integration. Relational data exists with personally identifiable entries, which is used as a fallback and considered critical for operations whilst the development is underway. The identifiable data is scheduled for deletion on January 1st 2023.

## Logging:

User transaction logs are anonymous, identifiable only with unique user IDs. With the use of Hypertext Transfer Protocol Secure (HTTPS) and encrypted double authentication to the third-party software responsible for personal data management, database entries are identified by cross-referencing the IDs. As a result, identification of entries and secure access to one's sensitive personal data is available within the application.

## Authentication:

The application integrates single sign-on with Microsoft Authentication Library (MSAL), which logs users' logins and signouts.
Learn about MSAL - Microsoft Entra
