> # Docker Setup

To run Ninox on-premise, we use Docker and Docker Compose. Here are the steps to set up Ninox on-premise using Docker:

1. **Install Docker**: Install Docker on your machine if you haven't already done so. You can download Docker from the official website.
2. **Create Dockerfile**: Create a Dockerfile with the following line of code:

```docker
FROM ninoxdatabase/ninox-on-premise:latest
```

This will pull the latest Ninox on-premise image from the Ninox Docker profile.

3. Create Docker Compose file: Create a Docker Compose file with the following code:

```yaml
version: "3.3"

services:
  nxdb:
    build: .
    ports:
      - 6999:8080
      - 587:587
    volumes:
      - NX_DATA:/var/nxdb
      - /var/www/html/ninox/config/server-config.json:/usr/local/nxdb/server-config.json
      - /etc/letsencrypt/live/ninox.dialogueone.com/:/usr/local/nxdb/config/
    restart: always
    deploy:
      restart_policy:
        condition: any
        delay: 5s
        max_attempts: 3

volumes:
  NX_DATA:
```

This will create a Docker container for the Ninox on-premise image and expose the necessary ports. The `volumes` section maps the container's data to the host machine's `NX_DATA` directory, and mounts the server configuration file and SSL certificate directory.

4. **Build and run container**: Build the container using the `docker-compose build` command, then start the container using the `docker-compose up -d` command.

## Accessing Ninox

To access Ninox, we use port forwarding with Apache web server. Here is an example configuration file for Apache that forwards traffic from port 587 to Ninox on port 6999:

```apacheconf
<VirtualHost *:587>
ServerName www.ninox.dialogueone.com
ServerAlias ninox.dialogueone.com
SSLEngine on
SSLProxyEngine on
SSLProxyVerify none
SSLProxyCheckPeerCN off
SSLProxyCheckPeerExpire off
SSLProxyCheckPeerName off

ProxyPreserveHost on
ProxyPass / http://localhost:6999/
ProxyPassReverse / http://localhost:6999/
Include /etc/letsencrypt/options-ssl-apache.conf

SSLCertificateFile /etc/letsencrypt/live/ninox.dialogueone.com/fullchain.pem
SSLCertificateKeyFile /etc/letsencrypt/live/ninox.dialogueone.com/privkey.pem
</VirtualHost>

```

This configuration file listens on port 587 for incoming traffic and forwards it to Ninox running on port 6999. The `ProxyPass` and `ProxyPassReverse` directives ensure that the traffic is properly redirected to the Ninox server.

To access Ninox, you can visit `https://ninox.dialogueone.com` in your web browser. You will be prompted to enter a username and password to log in to the Ninox dashboard.

In addition to port forwarding, we also use SSL encryption with Let's Encrypt SSL certificates to ensure that the connection to Ninox is secure. The SSL certificates are configured in the Apache configuration file as shown above.

## Conclusion

In conclusion, Ninox on-premise is a powerful and flexible solution for building custom SaaS applications. By using port forwarding with Apache and SSL encryption with Let's Encrypt, we can provide a secure and reliable platform. If you encounter any issues with accessing Ninox, consult the official Ninox documentation or contact our support team for assistance.
