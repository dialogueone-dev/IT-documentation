> # Getting started

## Code Documentation:

The code documentation will provide a detailed explanation of how the application works, including its various components and how they interact with each other. This will include details on the PHP, MSAL library, Javascript NFC chip reading API, MySQL database, and Material Design front-end framework.

Overall, your application provides a modern and efficient solution for tracking employee lunch purchases in the workplace canteen. Its digital nature eliminates the inefficiencies and inaccuracies of traditional tracking methods, improving overall efficiency and accuracy while providing an improved user experience.

To get started with the application, you will need SSH access to the server on which it resides. The server is leased from our IT service provider Sotea. Once you have SSH access, you can use Visual Studio Code to connect to the server and begin working with the code.

### Here are the steps to get started:

- Obtain SSH access to the server from your IT service provider.
- Install Visual Studio Code on your local machine.
- Connect to the server using Visual Studio Code's built-in SSH connection feature.
- Once connected, navigate to the directory where the application is installed.
- Begin working with the code.

If you are new to SSH or Visual Studio Code, we recommend consulting their respective documentation for more information on how to set up and use these tools.

> [!Warning]
> Note that any changes made to the code on the server will be immediately reflected in the live application, so it's important to exercise caution and thoroughly test any changes before deploying them.

### Working Locally with XAMPP

If you're developing the application locally, you can use XAMPP to set up a local development server. XAMPP is a popular open-source web server solution that includes the Apache web server, MySQL database, and PHP. This section will guide you through setting up a local development environment and working with the application locally.

Here are the steps to set up a local development environment using XAMPP:

- Download and install XAMPP on your local machine.
- Start the Apache and MySQL servers in XAMPP.
- Copy the application files from the remote server to your local machine.
- Configure the application to use the local database instead of the remote database.
- Begin making changes to the code and testing them locally.

> [!NOTE]
> However, there is a caveat when working with authorized pages in the application. MSAL (Microsoft Authentication Library) is used to handle authentication and authorization, and some pages require authorization to access. To ensure that MSAL works properly when working locally, you need to configure the authorized pages in MSAL to include your local development environment.

Here are the steps to configure authorized pages in MSAL:

- Sign in to the Azure portal.
- Go to the Azure Active Directory > App registrations page.
- Select the application registration used by the application.
- Under the "Authentication" tab, add the URL for your local development environment to the list of authorized redirect URIs.
- Save the changes.

By following these steps, you can ensure that MSAL works properly when working with authorized pages in the application. It's important to note that any changes made to authorized pages can affect the security and stability of the application, so be sure to thoroughly test any changes and follow best practices for securing sensitive information.
