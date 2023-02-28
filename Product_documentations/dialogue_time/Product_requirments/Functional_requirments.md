> # Functional Requirement

There are two stages to the functional requirements. The original requirements must first be met, and then we
could start working on the updated requirements.

## The original requirements

Dialogue Time was initially centred around the consultants working in the business unit. However, since most
consultants employed have a freelance contract type, the requirements revolved around the freedom to choose
when they work. They would then invoice their hours accordingly using the application.

This makes the user flow and functional requirements different from similar tools like Planday since there is a
need to be able to organize and plan employee capacity and output for the upcoming months for clients.
However, a need for flexibility allows consultants to change their schedules and log their hours at will.

Other requirements also include:

- Administrative features.
  - Adding hours for consultants or schedule for them.
  - Adding, updating or removing tasks or projects.
  - Editing consultants schedule and hours logged.
  - Exporting data.
- User features
  - Exporting of hours logged.
  - Overview of schedule.
  - Overview of hours logged.
  - Overview of company’s entire schedule.
  - Table capacity booking system (schedule).

## The updated requirements

Not only includes both the original requirements mentioned and also the integration capabilities mentioned in the
business case.

### Self service integration

As a part of the automation requirements of the project, specific procedures were revisited and redefined, with
the end goal being the reduction of administrative overhead. Part of this was self-service integration, where
consultants have more control of their data, hours, schedule etc.

### Payroll

Previously, hours were logged as single entries, and the CEO would review these entries before paying salaries at the end of each salary period. However, this process was found to be costly and convoluted for a growing company. It was observed that some entries may be incorrect, and some consultants may require special circumstances such as deferring hours to the next period. As a result, the procedures involved were revisited with the CEO.

Web and mobile banking were used as examples to integrate self-service features and implement stricter protocols for data consistency and accuracy of the hours logged. An integrated self-service API was envisioned to perform the same tasks as the CEO and provide better validation.

This functionality would provide a more efficient experience for the consultants, enabling them to defer their hours to the next periods and quickly access their upcoming and past salary balances. Additionally, the database was redesigned to use double transactional data for hours logged, which created a ledger for salary purposes.

### Personal data

The administration of employee personal data in the company was previously a manual process, where physically signed documents were scanned and uploaded to a shared folder structure. This process was manageable until the company started growing, and the fluctuation of consultants increased, creating increased administrative work. To alleviate this administrative overhead in the HR department, a self-service portal was created inside Dialogue Time, where consultants can review and update their personal data.
