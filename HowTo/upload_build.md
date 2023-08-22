> # Uploading Dialogue Time Build

This documentation shows how to upload a Dialogue Time build to the server.

> Logins and passwords can be found at the IT administrator.

## Prerequisites

- You need to have access to the server.
- You need to have a Dialogue Time build.
- You need to have a FTP client **(FileZilla is recommended)**.

## Building Steps

1. Open Visual Studio code and open the Dialogue Time project.
2. Open a terminal and navigate to the project folder.
3. Open the `public/custom-service-worker.js` file and change the `const v` variable to the current build version.
4. Open a terminal and run this command.

```bash
yarn build
```

4. After the build is done, navigate to the `build` folder.

## Uploading Steps

1. Open your FTP client and connect to the server.
2. Navigate to the `/home/ftpdialogue/ftp/files/` directory.
3. Delete the old Dialogue Time build (dialogue_time_v2).
4. Upload the new Dialogue Time build to the server and rename it to dialogue_time_v2.
5. Open a terminal and connect to the server.
6. Navigate to the `/var/www/html` directory and run this command.

```bash
sudo rm -rf dialogue_time_v2_copy && sudo mv dialogue_time_v2 dialogue_time_v2_copy && sudo cp -rf /home/ftpdialogue/ftp/files/dialogue_time_v2 .
```

After running this command you have deleted the old Dialogue Time build copy, renamed the current Dialogue Time build to Dialogue Time build copy and copied the new Dialogue Time build to the server.
