> # Managing admins in Dialogue Time

In order to manage the administrators for the Dialogue Time application, we utilize Microsoft Azure Active Directory and the security group called `Dialogue_time_admins`. By adding or removing users from this security group, we can grant or revoke administrative access to the application.

## Service

Responsible people for this service are:

- [Jens Petersen-Westergaard](mailto:jpw@dialogueone.dk?subject=Dialogue%20Time%20Admins%20Service%20Request)
- [Sotea](mailto:support@sotea.dk?subject=Dialogue%20Time%20Admins%20Service%20Request)

The steps below describe how to add or remove admins for the Dialogue Time application using Azure Active Directory and the `Dialogue_time_admins` security group.

## Adding Admins

1. Navigate to the Microsoft Azure portal at [portal.azure.com](https://portal.azure.com) and sign in with your Azure AD administrator account.

2. In the Azure portal, search for and select "Azure Active Directory" from the services.

3. In the Azure Active Directory blade, select "Groups" from the left-hand menu.

4. Search for the group named `Dialogue_time_admins` and click on it to open the group details.

5. In the group details, click on the "Members" tab.

6. Click on the "Add members" button to add new admins to the group.

7. In the "Add members" window, search for and select the users you want to add as admins for the Dialogue Time application.

8. After selecting the users, click on the "Add" button to add them to the group.

9. The selected users are now added as admins for the Dialogue Time application. They will have the necessary permissions and access rights.

## Removing Admins

1. Follow steps 1 to 4 from the "Adding Admins" section to navigate to the group details of `Dialogue_time_admins`.

2. In the group details, click on the "Members" tab to view the current admins.

3. Locate the admin user you want to remove from the group and click on the ellipsis (`...`) next to their name.

4. From the options that appear, select "Remove from group" to revoke their admin access.

5. Confirm the removal when prompted.

6. The selected user is now removed from the `Dialogue_time_admins` group, and their admin access to the Dialogue Time application is revoked.

Note: It may take a few minutes for the changes to propagate and reflect the updated admin status for the Dialogue Time application.

That's it! You have successfully documented the process of adding and removing admins for the Dialogue Time application using Azure Active Directory and the `Dialogue_time_admins` security group.
