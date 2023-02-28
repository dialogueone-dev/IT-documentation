> # WebSocket

To improve internal communication within the company, the application features announcements. Consultants may not always read informational posts on Teams, which is why it was important to add this feature to Dialogue Time. Using WebSockets, the announcement system ensures that consultants receive important updates when they log in to the application. This helps to ensure that consultants don't miss important information that may affect their hours or pay.

## What are websockets

WebSockets is a protocol that allows for real-time communication between a client (such as a web browser) and a server. Unlike traditional HTTP requests, where the client sends a request and the server responds with a single response, WebSockets enable two-way communication between the client and server.

With WebSockets, a connection is established between the client and server, and this connection stays open, allowing for data to be sent between the two parties in real-time. This makes it ideal for applications that require real-time updates, such as chat applications or real-time multiplayer games.

WebSockets use a special handshake process to establish the connection between the client and server, and a specific data framing format for sending and receiving messages. It is supported by most modern web browsers and can be implemented using various programming languages and frameworks.

Here are examples of setting up a WebSocket connection in both the frontend and backend using the ws npm package:

Backend (Node.js):

```js
// Import WebSocket library
const WebSocket = require("ws");

// Create WebSocket server
const wss = new WebSocket.Server({ port: 8080 });

// Handle connection event
wss.on("connection", function connection(ws) {
  console.log("A client has connected!");

  // Handle message event
  ws.on("message", function incoming(message) {
    console.log("Received message: %s", message);
  });

  // Handle close event
  ws.on("close", function close() {
    console.log("A client has disconnected.");
  });
});
```

Frontend (browser):

```js
// Create WebSocket connection
const ws = new WebSocket("ws://localhost:8080");

// Handle connection event
ws.onopen = function () {
  console.log("WebSocket connection established.");
};

// Handle message event
ws.onmessage = function (event) {
  console.log("Received message: ", event.data);
};

// Handle close event
ws.onclose = function (event) {
  console.log("WebSocket connection closed with code ", event.code);
};

// Send message
ws.send("Hello, server!");
```

## Our implementation

Our implementation offers a function that exports a WebSocket server to support real-time communication between the server and clients. This function utilizes several modules, including queryString to parse query parameters from the client's connection URL, WebSocket to create a WebSocket server object, and custom controller modules (Global and HR) to handle notifications. Additionally, the jwt module is used for API token authentication.

The function takes an expressServer object as an argument, which is then used to handle WebSocket upgrades. When a client connects to the server, a new WebSocket connection is created, and the websocketConnection object listens for messages from the client.

If the message has an APIToken property, the token is verified, and if successful, the parsedMessage object is examined to determine the appropriate action. If the Intent property of the message is "Sign," the websocketConnection object is assigned user ID, bearer, and API token properties.

If the Intent is "Mark as read," the corresponding notification is marked as read. If the Intent is "Public announcement," the relevant announcement is sent to the client. If the Intent is "Get unread messages," unread messages are sent to the client. If the Intent is "Inform HR Master Data Change," an HR master data change is sent to the client.

Clients are stored as a Map object that retains their information, and when the websocketConnection object is closed, the client is removed from the clients Map.

`/var/www/html/apiV2/websockets/index.js`

### Importing and setting schedule

In our implementation, two schedules are created for sending log schedule reminders and log hours reminders respectively. These schedules are created using the node-schedule module and are set to run at specific times of the month. The functions called by the schedules are implemented in the public_notification module, and they send reminders to users for logging schedules and hours.

```js
// Import required modules
import queryString from "query-string";
import WebSocket from "ws";
import Global from "./controllers/public_notification";
import HR from "./controllers/hr_notification";
import jwt from "jsonwebtoken";
import schedule from "node-schedule";

require("dotenv").config();

// Schedule a job to run at 10:01 AM on the 10th day of every month,
// which sends reminders for schedules
const job = schedule.scheduleJob("10 1 10 * *", function () {
  Global.CreateAndSendLogScheduleReminder();
});

// Schedule a job to run at 10:01 AM on the 20th day of every month,
// which sends reminders for logging hours
const job2 = schedule.scheduleJob("10 1 20 * *", function () {
  Global.CreateAndSendLogHoursReminder();
});
```

### On upgrade

This code exports an asynchronous function that takes an instance of an Express server as an argument. The function sets up a WebSocket server using the WebSocket module, which listens to requests on the "/websockets" path and uses the same server port as the express server.

An event listener is then set up on the express server to listen for upgrade events. These events are triggered when a client requests an upgrade to a WebSocket connection. The handleUpgrade method of the WebSocket server is called to handle the upgrade. The method takes in the request, socket, and head arguments and a callback function that emits a connection event with the new WebSocket connection and the original HTTP request.

```js
// Define a function to create a WebSocket server and handle client connections
export default async (expressServer) => {

  const websocketServer = new WebSocket.Server({
    noServer: true,
    path: "/websockets"
  });

  // Listen for upgrade requests on the Express server and upgrade to WebSocket connection
  expressServer.on("upgrade", (request, socket, head) => {
    websocketServer.handleUpgrade(request, socket, head, (websocket) => {
      websocketServer.emit("connection", websocket, request);
    });
  });
// ...
```

### Clients and messages

Here, we set up a listener for the connection event on the websocketServer object. This function is called whenever a new client connects to the WebSocket server. Inside the function, we perform the following steps:

- Parse the query parameters from the connection URL to extract any additional information that the client may have sent.
- Generate a unique ID and color for the client, and store this information in the clients map.
- Set up a listener for the message event on the WebSocket connection. This function is called whenever the client sends a message to the server.
- Parse the message from the client and verify the JWT token for authentication.
- Depending on the intent of the message, call the appropriate function to handle the message.
- Set up a listener for the close event on the WebSocket connection. This function is called when

```js
const clients = new Map();

// Listen for WebSocket connections and handle messages from clients
websocketServer.on(
  "connection",
  function connection(websocketConnection, connectionRequest) {
    const [_path, params] = connectionRequest.url.split("?");
    const connectionParams = queryString.parse(params);

    const id = uuidv4();
    const color = Math.floor(Math.random() * 360);
    const metadata = { id, color };

    clients.set(websocketConnection, metadata);

    // Handle messages from clients
    websocketConnection.on("message", (message) => {
      const parsedMessage = JSON.parse(message);

      if (!parsedMessage.APIToken) {
        clients.delete(websocketConnection);
        return websocketConnection.send(
          JSON.stringify({ auth: false, message: "No token provided." })
        );
      }

      // Verify JWT token for authentication and handle different intents of messages
      jwt.verify(
        parsedMessage.APIToken,
        process.env.API_secret,
        function (err, decoded) {
          if (err) {
            console.error(err);
            websocketConnection.send(
              JSON.stringify({
                auth: false,
                message: "Failed to authenticate token.",
              })
            );
            clients.delete(websocketConnection);
            return;
          }
          if (parsedMessage.Intent === "Sign") {
            websocketConnection.UserID = parsedMessage.UserID;
            websocketConnection.Bearer = parsedMessage.Bearer;
            websocketConnection.APIToken = parsedMessage.APIToken;
          }
          if (parsedMessage.Intent === "Mark as read") {
            if (parsedMessage.Group.channel === "HR") {
              HR.MarkAsRead(websocketConnection, parsedMessage);
            } else {
              Global.MarkAsRead(websocketConnection, parsedMessage);
            }
          }
          if (parsedMessage.Intent === "Public announcement") {
            if (parsedMessage.Group === "Public") {
              Global.Public(parsedMessage, clients);
            } else {
              Global.Channels(websocketConnection, parsedMessage, clients);
            }
          }
          if (parsedMessage.Intent === "Get unread messages") {
            HR.GetUnread(websocketConnection);
            Global.GetUnread(websocketConnection);
          }
          if (parsedMessage.Intent === "Inform HR Master Data Change") {
            HR.InformOfChange(websocketConnection, parsedMessage, clients);
          }
        }
      );
    });

    websocketConnection.on("close", () => {
      clients.delete(websocketConnection);
    });
  }
);

function uuidv4() {
  return "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace(/[xy]/g, function (c) {
    var r = (Math.random() * 16) | 0,
      v = c == "x" ? r : (r & 0x3) | 0x8;
    return v.toString(16);
  });
}

return websocketServer;
```
