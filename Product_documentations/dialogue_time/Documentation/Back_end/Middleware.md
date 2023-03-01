> # Middleware

In Node.js, middleware refers to a series of functions that execute in sequence during the processing of a request to a web server. Middleware functions can perform a variety of tasks, such as modifying the request or response objects, logging, and authentication.

In essence, a middleware function sits between the client and the server, intercepting and processing incoming requests before they reach the final destination. Each middleware function can either modify the request object, the response object, or simply pass them along to the next middleware function in the chain.

Middleware functions can be thought of as a pipeline. When a request comes in, it first flows through the first middleware function, which can modify the request object before passing it on to the next middleware function in the chain. This continues until the final middleware function has processed the request and sent a response back to the client.

Middleware functions can be added to the pipeline using the app.use() method in Express, which is the most popular Node.js web framework. For example, the following code adds a middleware function that logs the incoming request method and URL to the console:

```js
// Importing the body-parser package
import bodyParser from "body-parser";

// Exporting a middleware function
export default (req, res, next) => {
  // Extracting the content type from the request header
  const contentType = req.headers["content-type"];

  // Checking if the content type is application/x-www-form-urlencoded
  if (contentType && contentType === "application/x-www-form-urlencoded") {
    // If it is, returning a middleware function that parses urlencoded bodies
    // with extended set to true, which allows the values of the body to be of any type
    return bodyParser.urlencoded({ extended: true })(req, res, next);
  }

  // If it is not application/x-www-form-urlencoded, returning a middleware function
  // that parses JSON bodies
  return bodyParser.json()(req, res, next);
};
```

In this example, the middleware function logs the request method and URL to the console and then calls next() to pass the request on to the next middleware function in the pipeline. Finally, the app.get() method adds a route handler for the root URL, which sends a response back to the client with the message "Hello World!". When the server is started, it will listen on port 3000 and log every incoming request method and URL to the console.

In our application we have a custom middleware setup. Although we use customary middleware, the structure may look different.

## Body parser

Body parser checks the "content-type" header of an incoming HTTP request and applies the appropriate parsing middleware from the body-parser package to extract the request body data.

The body-parser package is used to parse the request body of incoming HTTP requests and provides several middleware functions for different types of data that can be sent in the request body. This custom middleware inspects the "content-type" header of the incoming request to determine whether the data is in JSON format or in URL-encoded form.

```js
import bodyParser from "body-parser"; // Import body-parser package

export default (req, res, next) => {
  // Export middleware function with three parameters
  const contentType = req.headers["content-type"]; // Get content-type header from request

  if (contentType && contentType === "application/x-www-form-urlencoded") {
    // If content-type is urlencoded
    return bodyParser.urlencoded({ extended: true })(req, res, next); // Parse the request body as urlencoded and call next middleware
  }

  return bodyParser.json()(req, res, next); // Otherwise, parse the request body as JSON and call next middleware
};
```

This code checks if the content-type is "application/x-www-form-urlencoded", which is used for URL-encoded form data, the middleware applies the urlencoded() middleware from the body-parser package with the extended option set to true, indicating that the parsed data can be a nested object or array.

If the content-type is "application/json", the middleware applies the json() middleware from the body-parser package, which extracts the JSON data from the request body and converts it into a JavaScript object.

In both cases, the middleware passes the modified req, res, and next objects to the selected body-parser middleware function, which parses the request body and attaches the parsed data to the req.body property for further processing in downstream middleware or route handlers.

Overall, this middleware allows the application to handle incoming HTTP requests with different content types and extract the request body data for further processing.

## Methods

The Methods middleware function is responsible for checking if the incoming HTTP request method is one of the allowed methods defined in the allowedMethods array. If the method is not allowed, it sends a 405 Method Not Allowed response to the client with a message indicating that the method is not allowed.

The allowedMethods array includes the following HTTP methods: OPTIONS, HEAD, CONNECT, GET, POST, PUT, DELETE, and PATCH. These are common HTTP methods used for communication between clients and servers.

`/var/www/html/apiV2/middleware/requestMethods.js`

```js
export default (req, res, next) => {
  // NOTE: Exclude TRACE and TRACK methods to avoid XST attacks.
  const allowedMethods = [
    "OPTIONS",
    "HEAD",
    "CONNECT",
    "GET",
    "POST",
    "PUT",
    "DELETE",
    "PATCH",
  ];

  if (!allowedMethods.includes(req.method)) {
    res.status(405).send(`${req.method} not allowed.`);
  }

  next();
};
```

The purpose of this middleware is to prevent Cross-Site Tracing (XST) attacks by excluding the TRACE and TRACK methods, which can be used to exploit web vulnerabilities. If the request method is allowed, the middleware function calls next() to pass control to the next middleware function or route handler in the chain.

## Cors

Cors is a middleware function for handling CORS (Cross-Origin Resource Sharing) requests in an Express application using the cors npm package. CORS is a security feature in web browsers that restricts web pages from making requests to a different domain than the one that served the web page. The cors package provides a middleware function that can be used to set the CORS headers on the HTTP response for incoming requests.

`/var/www/html/apiV2/middleware/middleware/cors.js`

```js
import cors from "cors";
import settings from "../lib/settings";

// get the allowed urls from settings and add a few more
let urlsAllowedToAccess =
  Object.entries(settings.urls || {}).map(([key, value]) => value) || [];
urlsAllowedToAccess.push("https://dialogue-time.dialogueone.com");
urlsAllowedToAccess.push("https://app.ninox.com");
urlsAllowedToAccess.push("http://localhost:3000");

// create a configuration object for cors
export const configuration = {
  credentials: true,
  origin: function (origin, callback) {
    // check if the origin is allowed to access the API
    if (!origin || urlsAllowedToAccess.includes(origin)) {
      callback(null, true);
    } else {
      callback(new Error(`${origin} not permitted by CORS policy.`));
    }
  },
};

// use the cors middleware with the configuration object
export default (req, res, next) => {
  return cors(configuration)(req, res, next);
};
```

In this particular implementation, the urlsAllowedToAccess array is created by reading from the settings.urls object, and adding some default URLs to it. This array contains the URLs that are allowed to access the server. The configuration object is set up to allow credentials (such as cookies) to be passed along with the request, and to check the origin of the incoming request against the urlsAllowedToAccess array. If the origin is included in the urlsAllowedToAccess array, the callback is called with null as the first argument and true as the second argument, indicating that the origin is allowed. Otherwise, an error is thrown with a message indicating that the origin is not permitted by the CORS policy.

The cors middleware function is then called with the configuration object as an argument, and passed along to the next middleware function using next(). This middleware function ensures that the server is protected from unauthorized cross-origin requests.

## Authenticate

This is the function for verifying a JSON Web Token (JWT) in an Express.js application. It exports a function called VerifyToken which takes an array of roles as a parameter, and returns an array of middleware functions that will check if the JWT in the request header is valid and the user has the necessary role(s) to access the protected resource.

> Note: The authentication middleware is found in [Verification Middleware](Product_documentations/dialogue_time/Getting_started/Authentication/README?id=verification-middleware)

## Putting it all together

A file is used to define and configure middleware functions in an Express application.

The app.use() method in Express.js is used to mount middleware functions to a specified path or to the root path of an application. When a request is made to that path, the middleware function(s) attached to that path are executed in the order they are attached.

In the example below, app.use() is used to mount the following middleware.

`/var/www/html/apiV2/middleware/index.js`

```js
import express from "express";
import compression from "compression";
import cookieParser from "cookie-parser";
import favicon from "serve-favicon";
import requestMethods from "./requestMethods";
import cors from "./cors.js";
import bodyParser from "./bodyparser.js";

const middleware = (app) => {
  app.use(requestMethods);
  app.use(compression());
  app.use(favicon("public/favicon.ico"));
  app.use(express.static("public"));
  app.use(cors);
  app.use(bodyParser);
  app.use(cookieParser());
};

export default middleware;
```

- The compression middleware is used to compress the responses sent back to the client to save bandwidth.
- The cookie-parser middleware is used to parse cookies from incoming requests and expose them as a JavaScript object.
- The serve-favicon middleware is used to serve a favicon.ico file at the specified path.
- The express.static middleware is used to serve static files from the public directory.
- The cors middleware is used to handle Cross-Origin Resource Sharing (CORS) requests.
- The bodyParser middleware is used to parse incoming request bodies and expose them as a JavaScript object.
