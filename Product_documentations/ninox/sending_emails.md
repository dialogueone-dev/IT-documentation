> # Sending emails through Ninox

This document explains how to set up an email service for Ninox on a private server using Docker Compose. Specifically, it focuses on connecting an email account through a `server-settings.json` file and configuring the email account in Office 365 Admin to send emails on behalf of other users.

## Prerequisites

- Ninox on-premise installation on a private server.
- Docker and Docker Compose installed on the server.
- An Office 365 email account (e.g., ninox@dialogueone.dk).
- Office 365 admin credentials.

## Configuring Email in Ninox via Docker Compose

1. **Create a JSON File**: Create a `server-settings.json` file to store the email configuration.

   ```json
   {
      "email": {
         "host": "SMTP_HOST",
         "port": SMTP_PORT,
         "secure": true/false,
         "auth": {
            "user": "EMAIL_ADDRESS",
            "pass": "EMAIL_PASSWORD"
         }
      }
   }
   ```

2. **Update Docker Compose File**: Mount the `server-settings.json` file to the appropriate location in the Ninox container. Edit your `docker-compose.yml` file and add the following lines under the `volumes` section of your Ninox service.

   ```yaml
   volumes:
     - ./path_to_your/server-settings.json:/path_in_container/server-settings.json
   ```

3. **Restart Ninox Container**: Run the following command to apply the changes:

   ```sh
   docker-compose up -d
   ```

## Adding Users to 'Send As' Configuration

In cases where individual users need to be added to the 'Send As' configuration:

1. **Navigate to Exchange Admin Center**: From the Office 365 Admin Portal, go to `Admin centers` > `Exchange`.

2. **Go to Mailboxes**: Under `recipients`, click on `mailboxes`.

3. **Select the Email Account**: Find and select the email account (e.g., someuser@dialogueone.dk) you wish to configure.

4. **Manage Send As Permissions**: Under `delegation`, select the 'Send As' section and click `Add members`.

5. **Add Users**: Select the `ninox@dialogueone.dk` user to grant 'Send As' permissions to and click `Add`.

6. **Save Changes**: Click `Save` to apply the changes.

## Testing

Ensure that the email service is working properly by sending a test email through Ninox. Verify that the email is sent from the appropriate email address.

## Troubleshooting

If you encounter issues, check the following:

- Ensure that the `server-settings.json` file has the correct configuration.
- Confirm that the file is properly mounted in the Docker container.
- Verify that the 'Send As' permissions are configured correctly in Office 365.
