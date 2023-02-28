> # Integration requirements

## Emply

Emply is a SaaS product provisioned by the HR department that is used for managing HR-related tasks. It provides various modules that manage an employee's history in the company from pre-boarding to off-boarding. The product stores all relevant personal information about employees and adheres to strict GDPR regulations. It also offers API integration services to clients, including CRUD capabilities for personal information, employee-specific data such as department and supervisor, and more.

### The use case

- Data management.
  Access to strict GDPR automation tools.
  Allows for enhanced salary reporting.
  Employee self-service (users can change their data without involving HR).
  Removing user information from database storage, exchanging it for employee ID.
- User management.
  Department information decides what users see in Dialogue Time.
  Vacation and availability information becomes available in Dialogue Time.

## Ninox

Ninox is a highly customizable database management system used by Dialogue One as their CRM system. Consultants use this system to engage with contacts and create leads for clients. The end goal is to generate sales by contacting and/or booking meetings with companies. As a use case for API integration, Dialogue Time will automatically capture KPI information when consultants use it to invoice their hours.

### The use case

- Automatic KPI calculations.
- Callback alerts/reminders.
- Direct information flow for reporting tools.
- Live project planning dashboard.

## Sotea

Sotea is Dialogue One’s hosting service provider. They also provide Dialogue One with proxy servers and remote
desktop servers while administrating the company’s Microsoft corporate entity and subsequent servers.

## Danløn

An API connection to a salary provider can help automate the process of sending information to Danløn and reduce administrative overhead. Currently, the process involves manually reviewing the hours logged, exporting them to a specific format, and sending them forward, which can be time-consuming and prone to errors. By integrating with a salary provider's API, Dialogue One can automatically send the required information and reduce the need for manual intervention. This will allow the HR department to focus on more strategic tasks and improve overall efficiency.

## Product dependency risks

Ensure that the application does not crash if one or more of the integrated SaaS tools fail or stop. This can be achieved through various means, such as implementing fault-tolerant systems, utilizing backups or redundancy measures, and providing error handling and recovery mechanisms. The goal is to ensure that Dialogue Time remains operational and accessible to users even if one or more of the integrated SaaS services experience issues.
