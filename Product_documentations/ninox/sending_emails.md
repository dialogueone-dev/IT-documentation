> # Sending emails through Ninox

This document explains how to set up an email service for Ninox on a private server using Docker Compose. Specifically, it focuses on connecting an email account through a `server-settings.json` file and configuring the email account in Office 365 Admin to send emails on behalf of other users.

## Enabling Email Sending Through Ninox

To allow a user to send emails directly from Ninox, you need to grant Ninox permission to send emails on their behalf. Follow these steps:

1. Go to `Mailboxes` in the Exchange Admin Center (`Recipients` > `Mailboxes`), or use this direct link:  
   [https://admin.exchange.microsoft.com/#/mailboxes](https://admin.exchange.microsoft.com/#/mailboxes)
2. Select the user you want to enable email sending for.
3. Open the `Delegation` tab and click `Edit` under the `Send As` section.
4. Click `Add members`, then find and select `ninox@dialogueone.dk` from the list.  
   Click `Save`, and then click `Confirm` to apply the change.
5. You will see a confirmation message once the change has been submitted.

> [!NOTE]
> The change may take several hours to take effect.

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

## Troubleshooting

If you encounter issues, check the following:

- Ensure that the `server-settings.json` file has the correct configuration.
- Confirm that the file is properly mounted in the Docker container.
- Verify that the 'Send As' permissions are configured correctly in Office 365.
