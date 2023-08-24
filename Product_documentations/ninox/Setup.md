> # Docker Setup

To run Ninox on-premise, we use Docker and Docker Compose. Here are the steps to set up Ninox on-premise using Docker:

## Prerequisites

- **Operating System**: Ensure that your operating system is compatible with Docker. Supported platforms include Windows, macOS, and various Linux distributions.
- **Permissions**: You may need administrative or root permissions to install and run Docker.

## Installation and Configuration

### 1. Install Docker

- **Install Docker**: If you haven't already done so, download and install Docker from the [official website](https://www.docker.com/get-started).
- **Verify Installation**: Verify that Docker is installed correctly by running `docker --version` in your command line.

### 2. Create Dockerfile

> The Ninox on premise image is located at `var/www/html/ninox/`.

Create a Dockerfile in your project directory with the following line of code:

```docker
FROM ninoxdatabase/ninox-on-premise:latest
```

This will pull the latest Ninox on-premise image from the Ninox Docker profile.

### 3. Create Docker Compose File

Create a Docker Compose file (usually named `docker-compose.yml`) in the same directory as your Dockerfile with the following code:

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

This code will create a Docker container for the Ninox on-premise image and expose the necessary ports. The `volumes` section maps the container's data to the host machine's `NX_DATA` directory, and mounts the server configuration file and SSL certificate directory.

**Note**: Ensure that the directories mentioned in the `volumes` section exist on your host machine, and that the necessary permissions are set.

### 4. Build and Run Container

- **Build**: Build the container using the command `docker-compose build`.
- **Run**: Start the container using the command `docker-compose up -d`.

## Accessing Ninox

### Port Forwarding with Apache

To access Ninox, we use port forwarding with the Apache web server. Here is an example configuration file for Apache that forwards traffic from port 587 to Ninox on port 6999:

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

SSLCertificateFile {path to letsencrypt pub key}
SSLCertificateKeyFile {path to letsencrypt private key}
</VirtualHost>
```

**Note**: Ensure that Apache is properly installed and configured on your system, and that the necessary modules for proxying are enabled (e.g., `mod_proxy`, `mod_proxy_http`).

### Accessing the Dashboard

To access Ninox, visit `https://ninox.dialogueone.com` in your web browser. You will be prompted to enter a username and password to log in to the Ninox dashboard.

### SSL Encryption

In addition to port forwarding, we use SSL encryption with Let's Encrypt SSL certificates to ensure that the connection to Ninox is secure. The SSL certificates are configured in the Apache configuration file as shown above.

## Conclusion

In conclusion, Ninox on-premise is a powerful and flexible solution for building custom SaaS applications. By using port forwarding with Apache and SSL encryption with Let's Encrypt, we can provide a secure and reliable platform. If you encounter any issues with accessing Ninox, consult the [official Ninox documentation](https://docs.ninox.com/en/private-cloud-on-premises/docker-installation) or contact our support team for assistance.
