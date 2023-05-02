> # Getting started

## Requirements

- Microsoft Excel
- An account on Dialogue One A/s active directory with the necessary permissions to access the API.

## Installation

If you have an account on Dialogue One A/s active directory, you should be able to see the plugin in the `Add-ins` tab of the Excel ribbon. If you do not see the plugin, follow these steps to install it:

1. Download the plugin file from [insert location where plugin can be downloaded, e.g. Github, company website, etc.]
2. Open Microsoft Excel
3. Click on `File` and then `Options`
4. Select `Add-ins` from the left-hand menu
5. Click on the `Manage` dropdown menu and select `Excel Add-ins`
6. Click on `Browse` and select the plugin file you downloaded in step 1
7. Click `OK` to install the plugin
8. The plugin will now appear in the `Add-ins` tab of the Excel ribbon

## Authentication

The plugin uses Single Sign-On (SSO) authentication to access the API. Meaning it should automatically log you in if you are already logged in to your Dialogue One A/s account. If you are not logged in, you will be prompted to log in when you open the plugin.

## Node.js Server Setup

To support the Excel plugin, I set up a Node.js server that communicates with Dialogue Time API to retrieve KPI and scheduling data. Here's an overview of how I set up the server:

1. I uploaded the code for the Excel plugin to an internal server that I have.
2. I installed Docker on the server to make it more stable and to ensure consistent deployment.
3. I created a Dockerfile to build the Node.js server image with all necessary dependencies and configurations. I used the `node:14-alpine` base image and installed additional packages as needed, such as `npm`, `express`, and `request-promise-native`.
4. I used environment variables to store sensitive information such as the `clientId` and `clientSecret` needed to authenticate with the Dialogue Time API. These variables Ire passed to the Docker container when it was launched.
5. I exposed the necessary port(s) for the server to communicate with the Excel plugin.
6. I updated the `config.js` file with the appropriate `clientId`, `clientSecret`, and `baseUrl` values for our environment.
7. I launched the Docker container and tested the server to ensure that it was communicating correctly with Dialogue Time API.

By using this setup, I was able to retrieve KPI and scheduling data from our Dialogue Time API and display it in Excel without the need to manually export and import data through a Ib portal. The server runs continuously, ensuring that the data is always up-to-date and readily available for analysis and reporting.

## Configuring SSO Permissions and Scopes

To enable Single Sign-On (SSO) for the Excel plugin, I created an App registration in the Microsoft Azure portal and configured the necessary permissions and scopes. Here's an overview of the steps I took:

1. I logged in to the [Microsoft Azure portal](https://portal.azure.com) using our company account credentials.
2. I navigated to the `App registrations` section and clicked on `New registration` to create a new App registration.
3. I entered a name for the App registration and selected `Accounts in any organizational directory (Any Azure AD directory - Multitenant)` as the Supported account types.
4. I entered the appropriate Redirect URI(s) for the Excel plugin.
5. I clicked `Register` to create the App registration.
6. I navigated to the `API permissions` section and clicked on `Add a permission`.
7. I selected the appropriate API and permission(s) needed for the Excel plugin to access our Dialogue Time API, such as `access_as_user` or `openid`.
8. I clicked `Grant admin consent` to grant the necessary permissions to the App registration.
9. I updated the `clientId` and `clientSecret` fields in the `config.js` file of the Node.js server with the corresponding values from the App registration.

By configuring SSO permissions and scopes in this way, I was able to securely authenticate with our Dialogue Time API and retrieve KPI and scheduling data from it without the need to repeatedly enter login credentials. This makes the Excel plugin more efficient and user-friendly.

## Manifest file

The `manifest_local.xml` file is used to register the add-in within the organization's Integrated Apps section in the 365 Admin site. This file describes the add-in, its name, description, version, and permissions required to run.

The first part of the file specifies the app metadata, including its ID, version number, provider name, and other details such as icon URL, support URL, and default locale.

Next, the `AppDomains` section specifies the domains that the add-in can access. In this case, it's set to `dialogueone.com`.

The `Hosts` section specifies the Office applications in which the add-in can run. This add-in can run on Workbook, Document, and Presentation hosts.

The `DefaultSettings` section specifies the URL where the add-in is hosted. In this case, it's set to `https://project-status.dialogueone.com/home/index`.

The `Permissions` section lists the permissions required for the add-in to run. In this case, the add-in requires `ReadWriteDocument` permission.

The `VersionOverrides` section describes the add-in's user interface, including the commands and controls that the add-in will display. The `Hosts` section lists the hosts and their form factors where the add-in can display. The `Resources` section contains strings, images, and URLs that the add-in uses to display its user interface.

Finally, the WebApplicationInfo section provides information about the API permission scopes required by the add-in, such as `Files.Read`, `profile`, `openid`, `Directory.AccessAsUser.All`, `Directory.Read.All`, `User.Read.All`, `User.ReadBasic.All`, and `Group.Read.All`. This section also contains the add-in's `ID` and resource `URI`.
