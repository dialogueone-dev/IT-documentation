# Add User to Ninox

## Overview

To give a consultant access to Ninox, the following three steps need to be taken:

1. The new user signs in at [https://dialogue-one.ninoxdb.com](https://dialogue-one.ninoxdb.com) using their Microsoft account.
2. An admin updates the new user's details (display name, first name, and last name) in Ninox Settings > `Collaborators`.
3. An admin adds them to the correct workspace (project) with the appropriate role in Ninox Settings > `Workspaces`.

This process ensures the user can access and work in the relevant Ninox database.

Below is a detailed guide on all of the above steps.

## Step-by-Step Guide

### 1. New User Login

Ask the new user to log in to Ninox using their Microsoft account:  
[https://dialogue-one.ninoxdb.com](https://dialogue-one.ninoxdb.com)

Once they sign in, the user will appear in Ninox.

### 2. Set User Details in Ninox

After the user has logged in, follow these steps:

1. Go to the Ninox settings by clicking the gear icon in the top right corner and choosing `Ninox Settings`.
2. In the left menu, select `Collaborators`.
3. Find the new user (they’ll be listed with their email only).
4. Click on their email to edit the profile.
5. Fill in the **display name**, **first name**, and **last name** (make sure the spelling is correct).
6. Click `Save` at the bottom.

### 3. Add User to a Workspace

Now that the user's details are updated, they need to be added to the right workspace:

1. Still in the Ninox Settings, select `Workspaces` in the menu on the left side.
2. Select the relevant workspace.
3. Under `Members`, find and select the user’s email.
4. Select their role (for project leads and project consultants, choose **Editor**).
5. Click `Add to Workspace`.

The user can now access and work in the database.

## Troubleshooting

If the user cannot log in to Ninox, try the following:

- **Check Azure AD settings**:
  In Azure AD, under the user’s properties, make sure the Office Location field is set to "Ninox".
  If it’s missing, contact our IT provider itm8 to add it.

- **Clear browser cache**:
  Clear the browser’s cookies and cache, then try logging in again. Make sure to clear cookies and cache for all time, as clearing e.g. only the last hour is often not enough.

- **Check if the user already exists in Ninox**:  
  Go to Ninox Settings > `Collaborators` and check if the user is already listed.
  If the user is listed in Ninox, try the following:
  1. Still in `Collaborators`, click on the user’s email.
  2. Check if the `Enable for licensing` setting is turned off.
  3. If it is off, enable it and click `Save` at the bottom of the page.

> [!NOTE]
> To enable email sending through Ninox, please contact IT or follow the advanced guide [here](Product_documentations/ninox/sending_emails.md).
