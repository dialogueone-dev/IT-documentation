> # Project definition

Dialogue Time is a web-based application designed to log hours and schedules. It was developed in-house using a LAMP stack and named through popular vote. While the current iteration of the product was custom-made from scratch, the original concept of the website was deemed appropriate as a starting point for creating a centralized system due to its independent application posture.

## Stakeholders

Dialogue Time serves many stakeholders; however, the priority stakeholder is the company’s business units,
which generally consist of team leaders, project leaders and consultants who work on sales. The use case varies
significantly between the business unit and the other departments. Whilst the business unit uses the application
for day-to-day operations, utilizing the data captured in project and sales management, the other departments use
it primarily to log their hours and schedule their work days.

## Target and user groups

Dialogue Time has two user groups, the first being any consultant working for the company. The other is the
admin group which does administrative tasks like capacity planning, project management, sales reporting and
salary. Potential target groups exist for Dialogue Time, and they could be any consultancy company/agency that
operates similarly to Dialogue One, where consultants have a freelance type contract. The solution can remove
much overhead for a company by automating processes with the integration of other SaaS

## Preliminary product vision

The intention is to create a centralized environment where seemingly unconnected applications exchange data.
The product will not be a replacement for any third party provisioned software. However, since each of the
provisioned tools has different use cases and use cases for Dialogue Time, specific integration features will be
implemented where they make sense regarding Dialogue Time only.

## Scope

To implement an API first full-stack solution using industry-standard techniques and tools, integrating the
applications with third party SaaS where correlation exists.

The scope of which includes:

- A new user management and authentication process.
- Increased GDPR compliance and security.
- Increased automation and efficiency.
- Improved UI/UX

## Impact

Integrating API connections between the third party software that Dialogue One A/s provisioned to date will
likely reduce administrative overhead, expecting a reduction in redundancy from repetitive tasks. Evident in
all departments are user management flows which could be made redundant by introducing SSO and project
management tasks that could be managed by a single software rather than many.

### Automation

The need for creating a centralized application comes from the company’s recent growth; departments are
experiencing more administrative overhead, which might otherwise be automated to increase efficiency.
This automation includes:

- Automatic deletion of personal data in all systems.
- Actions that trigger programmed features like sending an email.
- Access to personal information, allowing consultants to update their info without involving HR.
- Automatic KPI calculations.
- A single user management system from On-boarding to Off-boarding.
- A more advanced payroll system.

### Improved Services

The integration allows the product to offer better services to the target group by relieving overhead and offering
new features that support sales. It potentially creates an opportunity for Dialogue One to develop a new business
model, expanding its sales operations into the SaaS market by providing API services.

### Future development

The creation of this product simplifies the implementation of new features and digital products; it also opens the
door for acquiring other third-party services with better cost-effectiveness since interfacing with the API should
be easy for future developers.

## Project approach

To facilitate the project, an MVP was created with the existing features of Dialogue Time. This allowed for the initial release of the product, with new functionality to be developed subsequently. The project was divided into functional pieces, each assigned a version number and prioritized based on their impact. This approach ensured that the most impactful functionalities were given priority.

## Project Organization

### Project management process

The project was managed using well-known tools and methodologies. The Agile Scrum methodology, which combines agile philosophy and the scrum framework, was used for development. Jira, a product from Atlassian, was the tool used for this approach. Jira can assign tasks, define road-maps, connect to the GIT code base for reviewing purposes, and more. Atlassian also offers Confluence, a text-based document creator that is well-suited for project definitions and management.

### Agile scrum

Scrum is a type of agile methodology that is well-suited for breaking projects into manageable chunks, making it a good choice for businesses that need to complete specific projects quickly. Other project management methodologies, such as the waterfall method, often emphasize building an entire solution at once. While this approach may be feasible if the product's functional and non-functional requirements are perfectly defined, agile scrum takes into account the need for functionality alteration.

The product was built in stages, with the MVP being the first stage launched into production. Each subsequent stage was assigned a different version number. Service workers on the client side detected the new version number once a new version was pushed to production, prompting users to update their PWA application.

### Review points

In order to keep on top of the backlog, we have biweekly meetings with the main stakeholders to discuss the
current status of the roadmap. Taking it further, we also throw quarterly meetings where we analyse what
resources were allocated during the quarter and discuss what output came from that, which leads us to plan more
accurately for the upcoming quarter.

### GIT

The Development, Testing, and Production GIT branching strategy was adopted for the project. All developers worked on and pushed unfinished component code to the development branch. Once the components were complete, they were pushed to the testing branch. If the usability testing was satisfactory, the changes were merged into the production branch.
