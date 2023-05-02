> # app.js

This part of the documentation goes over how the app.js file works. The app.js file is the entry point for the application. It is responsible for creating the Express app, configuring it, and starting the server.

## Initialization

This section initializes the dotenv library if the Node environment is not set to production. The dotenv library is used for loading environment variables from a .env file into process.env.

```js
if (process.env.NODE_ENV !== "production") {
  require("dotenv").config();
}
```

## Dependencies

These lines of code import the necessary dependencies for the application:

- `http-errors`: a library for creating HTTP error objects
- `express`: the Node.js framework for building web applications
- `path`: a built-in Node.js module for working with file paths
- `cookie-parser`: middleware for parsing cookies from HTTP requests
- `logger`: middleware for logging HTTP requests and responses

```js
var createError = require("http-errors");
var express = require("express");
var path = require("path");
var cookieParser = require("cookie-parser");
var logger = require("morgan");
```

## Create Express App

This line creates a new instance of the express framework, which represents the entire application.

```js
var app = express();
```

## Middleware

These lines of code define the middleware functions that the Express app will use to handle HTTP requests and responses:

- `logger`: logs HTTP requests and responses to the console
- `express.json()`: parses JSON-encoded HTTP request bodies
- `express.urlencoded()`: parses URL-encoded HTTP request bodies
- `cookieParser`: parses cookies from HTTP requests

```js
app.use(logger("dev"));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
```

## View Engine

These lines of code configure the Express app to use the Pug view engine for rendering HTML templates. The `views` setting defines the directory where the views are located, and the `view engine` setting specifies the template engine to use.

```js
app.set("views", path.join(__dirname, "views"));
app.set("view engine", "pug");
```

## Static Files

This line of code serves static files from the `public` directory using the `express.static` middleware.

```js
app.use(express.static(path.join(__dirname, "public")));
```

## Routes

These lines of code define the HTTP routes for the application, which correspond to different URLs that the user can navigate to:

- `/home/index`: the route for the task pane page
- `/getuserfilenames`: the route for retrieving the list of project status files
- `/project_status`: the route for retrieving project status data
- `/getuserinfo`: the route for retrieving user information

```js
var indexRouter = require("./routes/index");
var getFilesRoute = require("./routes/getFilesRoute");
var project_status = require("./routes/retrieve_project_status");
var getuserinfo = require("./routes/getuserinfo");

app.use("/home/index", indexRouter);
app.get("/getuserfilenames", getFilesRoute);
app.post("/project_status", project_status);
app.post("/getuserinfo", getuserinfo);
```

## Error Handling

These lines of code define the middleware functions for handling errors in the application. The first middleware function creates a `404 Not Found` error if the requested URL does not match any of the defined routes. The second middleware function handles all other errors that occur in the application, including server errors and client errors such as `400 Bad Request`. The middleware function sets the `message` and `error` properties of the response locals object, which are used to render the error page using the Pug template engine. The middleware function sets the status code of the response to the error status code or `500 Internal Server Error` if no status code is provided.

```js
app.use(function (req, res, next) {
  next(createError(404));
});

app.use(function (err, req, res, next) {
  res.locals.message = err.message;
  res.locals.error = req.app.get("env") === "development" ? err : {};
  res.status(err.status || 500);
  res.render("error");
});
```

## Export

This line of code exports the Express app object from the app.js file so that it can be used in other files that require it.

```js
module.exports = app;
```
