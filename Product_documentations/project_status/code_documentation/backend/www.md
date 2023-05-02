> # www file

The www file is the entry point for the Node.js application. It is responsible for creating an HTTP or HTTPS server and listening for incoming requests. This file serves as a starting point for the application and sets the stage for everything else that follows.

When this file is executed, it initializes the Express app, sets up the server, and starts listening for incoming requests. It is an important part of the application's infrastructure and plays a vital role in the overall architecture of the system. Without it, the application would not be able to receive incoming requests and respond to them.

## Shebang

This line of code specifies the interpreter that should be used to run the script. In this case, it is node.

```sh
#!/usr/bin/env node
```

## Module Dependencies

These lines of code import the required modules for the file. `app` is imported from `../app`, which is the Express application object. `debug` is a module that enables logging for debugging purposes. `devCerts` is a module that provides HTTPS certificates for local development. `https` is the built-in Node.js HTTPS module. `fs` is the built-in Node.js file system module.

```js
var app = require("../app");
var debug = require("debug")("ssoapp:server");
var devCerts = require("office-addin-dev-certs");
var https = require("https");
var fs = require("fs");
```

## Get Port

These lines of code define the port number that the server will listen on. The `normalizePort` function normalizes the port number so that it can be used by the server. The function checks if the port number is a valid integer or string and returns the normalized port value. The port number is set as an environment variable or the default value of `3000` if no environment variable is set. The port value is then set on the Express app object.

```js
var port = normalizePort(process.env.PORT || "3000");
app.set("port", port);
```

## Create HTTP Server

This line of code starts the HTTP server by calling the `startServer` function with the `app` and `port` parameters.

```js
startServer(app, port);
```

## Normalize Port

This function normalizes the port value so that it can be used by the server. It checks if the port value is a valid integer or string and returns the normalized port value. If the port value is not a number, it returns `false`.

```js
function normalizePort(val) {
  var port = parseInt(val, 10);

  if (isNaN(port)) {
    // named pipe
    return val;
  }

  if (port >= 0) {
    // port number
    return port;
  }

  return false;
}
```

## Error Handling

This function handles HTTP server errors. If the error is not related to the server's `listen` event, it throws an error. If the error is related to the server's `listen` event, it logs a friendly error message to the console and exits the process with an error status code.

```js
function onError(error) {
  if (error.syscall !== "listen") {
    throw error;
  }

  var bind = typeof port === "string" ? "Pipe " + port : "Port " + port;

  // handle specific listen errors with friendly messages
  switch (error.code) {
    case "EACCES":
      console.error(bind + " requires elevated privileges");
      process.exit(1);
      break;
    case "EADDRINUSE":
      console.error(bind + " is already in use");
      process.exit(1);
      break;
    default:
      throw error;
  }
}
```

## Start Server

In the WWW file, a function called` startServer` is defined that takes two arguments: the express `app` and the `port`. This function first checks if the current `NODE_ENV` environment variable is set to "development". If it is, it calls the `devCerts.getHttpsServerOptions()` function to get HTTPS server options for the development environment. It then creates an HTTPS server using the `https` module with the obtained options and the `app`, and listens on the given `port`. If the current environment is not development, it simply calls the `app.listen()` function on the default port 1337.

Finally, the `startServer` function is called with the `app` and `port` values previously set, which starts the HTTP/HTTPS server based on the environment.

```js
async function startServer(app, port) {
  if (process.env.NODE_ENV === "development") {
    const options = await devCerts.getHttpsServerOptions();
    https
      .createServer(options, app)
      .listen(port, () => console.log(`Server running on ${port}`));
  } else {
    app.listen(process.env.port || 1337, () =>
      console.log(`Server listening on port 1337`)
    );
  }
}
```
