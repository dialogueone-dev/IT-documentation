> # Getting started

## Where are all the components?

The React.js front-end application and the backend API are both hosted on the same server provided by Sotea, our IT provider. SSH is used to access the server.

The React Front End is the user-facing part of the Dialogue Time application, and is responsible for rendering the UI and handling user interactions. It is built using modern web technologies, including React, Redux, and Axios, and is designed to be a Progressive Web App (PWA), which provides an app-like experience in the browser and allows users to install the app on their devices.

The API backend is the server-side part of the Dialogue Time application, and is responsible for handling requests from the front end, retrieving and manipulating data from the database, and sending back the appropriate responses. It is built using Node.js, Express, and MongoDB, and is designed to be scalable and modular, with separate modules for handling authentication, user management, and task management.

Together, the React Front End and API backend work in tandem to provide a seamless and efficient user experience, allowing users to log their hours, view their tasks, and interact with other users in real-time. The combination of modern web technologies, best practices in web development, and a focus on security and reliability make Dialogue Time a powerful and versatile tool for managing projects and teams in a fast-paced and dynamic environment.

### SSH

In order to access the server where the applications exist you need to connect to it via SSH, SSH stands for Secure Shell, and it is a network protocol that allows secure communication between two computers. It is commonly used to remotely access and manage computers and servers, as it provides a secure way to log in and execute commands over an unsecured network. With SSH, all data transmitted between the two computers is encrypted, ensuring that sensitive information such as passwords and other credentials are not intercepted by unauthorized users.

#### SSH inside Visual Studio code

SSH uses the terminal interface and can be a bit daunting for newcomers, but Visual Studio code offers an extension pack that allows you to set up a SSH connection, where you can then use the IDE like usual. Think about this as a you using visual studio code on your computer, but it's not your computer.

> Read more about it here [Link to SSH extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh)

Here's an example of how to add SSH into Visual Studio Code:

1. Open Visual Studio Code.
2. Open the Command Palette by pressing Ctrl+Shift+P on Windows or Cmd+Shift+P on macOS.
3. Type "Remote-SSH: Add New SSH Host" and select it.
4. Enter the SSH connection string in the format ssh user@host and press Enter.
5. Enter your SSH password if prompted.
6. Visual Studio Code will then prompt you to choose a folder to store the SSH configuration file. Choose a folder and save the file.
7. You can now access the remote server by clicking the "Remote Explorer" icon in the left-hand menu, selecting "SSH Targets", and then clicking on the server you just added.

To configure SSH in order to log in without a password:

1. Generate a new SSH key pair using the ssh-keygen command in your terminal.
2. Copy the public key to the remote server by running the command ssh-copy-id user@host.
3. Enter your SSH password when prompted.
4. You can now log in to the remote server without a password.

> To get the credentials to access the server please contact Jens the IT manager jpw@dialogueone.dk

## Building and uploading the application

You can find the instructions on how to build and upload the application here [Link to build and upload](HowTo/upload_build.md)

## Back end

The backend API is located under the file `/var/www/html/apiV2`

## Front End

The frontend application is the built version of the React app and is located at `/var/www/html/dialogue_time_v2`

### Development server

You'll need to have Yarn installed <https://yarnpkg.com/> to install the dependencies.

`yarn`

The yarn package manager should install all the dependencies.
then run

`yarn start`

### Starting point

The application starting point is `src/app/index.js`, much like a normal react app starting point. However here we also import our custom `store` and our `theme` (more on these later).

```js
import Authenticate from "./App/authenticate";
import { StoreProvider } from "./context/store.js";
import "assets/css/material-dashboard-react.css?v=1.10.0";
import "./index.css";
import { MaterialUIControllerProvider } from "context";
import "App/Views/Users/Schedule/schedule.css";
import "context";
import { createRoot } from "react-dom/client";
const container = document.getElementById("root");
const root = createRoot(container);
root.render(
  <MaterialUIControllerProvider>
    <StoreProvider>
      <Authenticate></Authenticate>
    </StoreProvider>
  </MaterialUIControllerProvider>
);
```
