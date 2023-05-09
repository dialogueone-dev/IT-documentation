> # Authentication

The product requirement for user authentication in Dialogue Time involves the utilization of SSO. The current system employs a traditional user management system that stores personal information and hashed passwords in a database, and includes features such as password recovery and manual recovery. However, this setup poses certain security risks such as SQL injection or breaches.

By incorporating SSO, Dialogue Time can enhance its security measures by implementing double authentication, thereby reducing the likelihood of password compromise. This also eliminates the need for user management in multiple systems, streamlining administrative tasks.

## Setup

If the user is not already logged in to their Outlook Account they will have to log in to their account before they can access the application. This is done by clicking on the "Sign in" button on the login page.
What happens then is that the user is redirected to the Microsoft login page where they can enter their credentials. After the user has entered their credentials and clicked on the "Sign in" button, they will be redirected back to the application. The application then has access to the users Microsoft Bearer Token, which can be used to access the Microsoft Graph API. We then make a call to `AuthService.login()` to authenticate the user once more in the backend and create a JWT token for the user. This token is used to interact with our backend API, whilst the Bearer Token is used to access the Microsoft Graph API.

### Authentication Code Flow

The following flow is used to authenticate a user:

- Bearer Token is obtained from Microsoft Graph API.
- Bearer Token is sent to the backend API.
- Backend API verifies the Bearer Token and retrieves AD user data.
- Backend API accesses AD groups to determine user roles.
- Backend API creates a JWT token for the user with the user data and roles.
- JWT token is sent back to the frontend.

### Configuring Application in Azure

To configure the application in Azure please take a look at the documentation [here](https://docs.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app).

## Frontend Setup

This section will cover the frontend setup for authentication.

### Authentication Service Routes

In the for of class based functions, we use `services` to make HTTP calls, the following module exports an AuthService class with methods for authentication and user registration.
It imports the http module from the `../Common_service/rest_http_common` file and the TokenService module from the `./token.service file`.

The AuthService class has four methods:

- `login(parameters)` sends a POST request to the `/auth/signin` endpoint with parameters data and sets the user token in the TokenService. Returns the response data.
- `logout()` removes the user token from the TokenService.
- `register(username, email, password)` sends a POST request to the `/auth/signup` endpoint with username, email, and password data.
- `getCurrentUser()` returns the user token from the TokenService.

The export default statement exports a new instance of the AuthService class as the default export of this module.

`src\services\REST_service\auth.service.js`

#### Defining AuthService Class

```js
import http from "../Common_service/rest_http_common";
import TokenService from "./token.service";
class AuthService {
  async login(parameters) {
    const response = await http.post("/auth/signin", { token: parameters });
    if (response.data.accessToken) {
      TokenService.setUser(response.data);
    }
    return response.data;
  }
  logout() {
    TokenService.removeUser();
  }
  register(username, email, password) {
    return http.post("/auth/signup", {
      username,
      email,
      password,
    });
  }
  getCurrentUser() {
    return TokenService.getUser();
  }
}
export default new AuthService();
```

### Token Service Routes

In tandem with the AuthService class, the TokenService class is used to handle the user's token. This class contains various methods that handle getting and setting data in the local storage of the client's browser. Each method corresponds to a specific object in the user's local storage.

- `getLocalRefreshToken()` - returns the user's refresh token.
- `getLocalAccessToken()` - returns the user's access token.
- `getLocalBearerToken()` - returns the user's bearer token.
- `getEmployeeData()` - returns the user's employee data.
- `updateLocalAccessToken(token)` - updates the user's access token.
- `getUser()` - returns the user object.
- `getRoles()` - returns the user's roles.
- `getUserID()` - returns the user's ID.
- `setUser(user)` - sets the user object in the local storage.
- `removeUser()` - removes the user object from the local storage.

`src\services\REST_service\token.service.js`

```js
class TokenService {
  getLocalRefreshToken() {
    const user = JSON.parse(localStorage.getItem("user"));
    return user?.refreshToken;
  }
  getLocalAccessToken() {
    const user = JSON.parse(localStorage.getItem("user"));
    return user?.accessToken;
  }
  getLocalBearerToken() {
    const user = JSON.parse(localStorage.getItem("user"));
    return user?.Bearer;
  }
  getEmployeeData() {
    const user = JSON.parse(localStorage.getItem("user"));
    return user?.EmployeeData;
  }
  updateLocalAccessToken(token) {
    let user = JSON.parse(localStorage.getItem("user"));
    user.accessToken = token;
    localStorage.setItem("user", JSON.stringify(user));
  }
  getUser() {
    return JSON.parse(localStorage.getItem("user"));
  }
  getRoles() {
    const user = JSON.parse(localStorage.getItem("user"));
    return user?.Role;
  }
  getUserID() {
    let user = JSON.parse(localStorage.getItem("user"));
    return user?.id;
  }
  setUser(user) {
    localStorage.setItem("user", JSON.stringify(user));
  }
  removeUser() {
    localStorage.removeItem("user");
  }
}
export default new TokenService();
```

### HTTP Common Service

The HTTP Common Service is used to make HTTP calls to the backend API. It is used by all `service` classes (except for the ones we make directly to Microsoft Graph), to make calls to the api endpoints. It is also used by the UserService class to make calls to the `/users` endpoint.

`src\services\Common_service\rest_http_common.js`

#### Importing the modules

```jsx
import axios from "axios";
import { Providers } from "@microsoft/mgt";
import TokenService from "services/REST_service/token.service";
```

This code is importing the axios library for making HTTP requests, the Microsoft Graph Toolkit (mgt) Providers object for handling authentication, and a custom TokenService from the REST_service folder for managing tokens.

#### Defining the GetToken function

```js
async function GetToken() {
  let token;
  try {
    token = await Providers.globalProvider.getAccessToken({
      scopes: ["User.Read"],
    });
  } catch (error) {
    console.log(error);
  }
  return token;
}
```

This code snippet is defining an asynchronous function called `GetToken()`.

Then, a try-catch block is used to call the `getAccessToken()` method of a global provider object with an argument specifying the scopes that should be requested for the access token. If the call is successful, the access token is assigned to the token variable. If there is an error, it is logged to the console.

Finally, the token variable is returned from the function.

#### Creating an Axios instance

```js
const instance = axios.create({
  baseURL: "https://api-v2.dialogueone.com/api",
  headers: {
    "Content-type": "application/json",
  },
});
```

This code creates an instance of the Axios HTTP client. It uses the `create()` method of Axios to create a new instance with a baseURL set to <https://api-v2.dialogueone.com/api>. The headers object specifies that the content type of requests made with this instance will be JSON. This instance can then be used to make HTTP requests to the specified base URL.

#### Adding the GetToken function to the instance

```js
instance.interceptors.request.use(
  async (config) => {
    const AccessToken = TokenService.getLocalAccessToken();
    const useruuid = TokenService.getUserID();
    const token = await GetToken();
    if (token) {
      config.headers.MSBearerToken = token;
      config.headers["x-access-token"] = AccessToken;
      config.headers["useruuid"] = useruuid;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);
```

This code intercepts outgoing requests from the instance Axios instance and adds headers for authentication. It first retrieves the access token and user UUID from the `TokenService` class, and then retrieves a new token using the `GetToken()` function. If the new token exists, it adds it, the access token, and the user UUID as headers to the request configuration. If an error occurs, it rejects the Promise with the error.

#### Handling expired access tokens

```js
instance.interceptors.response.use(
  (res) => {
    return res;
  },
  async (err) => {
    const originalConfig = err.config;
    if (originalConfig.url !== "/auth/signin" && err.response) {
      // Access Token was expired
      if (err.response.status === 401 && !originalConfig._retry) {
        originalConfig._retry = true;
        await instance
          .post("/auth/refreshtoken", {
            refreshToken: TokenService.getLocalRefreshToken(),
          })
          .then(function (data) {
            const { accessToken } = data.data;
            TokenService.updateLocalAccessToken(accessToken);
            return instance(originalConfig);
          })
          .catch(function (_error) {
            if (_error.response.data.message !== undefined) {
              alert(_error.response.data.message.message);
            }
            return Promise.reject(_error);
          });
      }
    }
    return Promise.reject(err);
  }
);
export default instance;
```

This code sets up a response interceptor for the axios instance. The response interceptor intercepts any response from the server before it's processed by the calling component. The response interceptor has two functions: one that handles a successful response, and another that handles an error response.

The function that handles a successful response just returns the response unchanged. The function that handles an error response checks if the request that caused the error was not a login request `("/auth/signin")`, and if it was caused by an expired access token `(401 status code)`. If so, it will try to refresh the access token by making a request to the server using the refresh token stored in local storage.

If the refresh token request succeeds, the access token in local storage is updated with the new access token, and the original request is retried with the updated access token. If the refresh token request fails, an error message is displayed, and the error is rejected.

Finally, the axios instance is exported for use in other parts of the application.

## Backend Setup

### Authentication routes

The routes for authentication do not utalize VerifyToken() just yet, as the user does not have JWT tokens to offer the API. The following flow is used to authenticate a user:

`app/routes/auth.routes.js`

#### Defining the Authentication routes

```js
module.exports = (app, VerifyToken) => {
  const controller = require("../controllers/auth.controller.js");
  const cors = require("cors");
  var router = require("express").Router();
  router.post("/auth/signin", controller.signin);
  router.post("/auth/refreshtoken", controller.refreshToken);
  app.use("/api", router);
};
```

This code is setting up a router for authentication. It is importing the auth.controller.js file which contains the signin and refreshToken functions. It then sets up two routes, one for signing in and one for refreshing the token. Finally, it uses the router with the app object to set up the routes on the server.

`app/models/RefreshToken.model.js`

#### Defining the RefreshToken model

```js
const config = require("../../config/auth.config");
const { v4: uuidv4 } = require("uuid");

module.exports = (sequelize, Sequelize) => {
  const RefreshToken = sequelize.define("refreshToken", {
    token: {
      type: Sequelize.STRING,
    },
    expiryDate: {
      type: Sequelize.DATE,
    },
    Account: {
      type: Sequelize.STRING(255),
      allowNull: false,
      noUpdate: true,
    },
  });
  RefreshToken.createToken = async function (user) {
    let expiredAt = new Date();
    expiredAt.setSeconds(expiredAt.getSeconds() + config.jwtRefreshExpiration);
    let _token = uuidv4();
    let refreshToken = await this.create({
      token: _token,
      Account: user.id,
      expiryDate: expiredAt.getTime(),
    });

    return refreshToken.token;
  };
  RefreshToken.verifyExpiration = (token) => {
    return token.expiryDate.getTime() < new Date().getTime();
  };

  RefreshToken.getUser = async function (userID) {
    let refreshToken = await this.findOne({ where: { Account: userID } });
    return refreshToken.Account;
  };
  RefreshToken.verifyExpiration = (token) => {
    return token.expiryDate.getTime() < new Date().getTime();
  };

  return RefreshToken;
};
```

This code is creating a model for a RefreshToken in a Sequelize database. It defines the fields of the model, creates a token with an expiration date, verifies the expiration of the token, and gets the user associated with the token.

`app/controllers/auth.controller.js`

```js
const db = require("../models/index.js");
const config = require("../../config/auth.config");
const API = process.env.Emply_api;
const Roles = db.ROLES;
const jwt_decode = require("jwt-decode");
const Op = db.Sequelize.Op;
const axios = require("axios");
const fetch = require("node-fetch");
require("dotenv").config();
const { refreshToken: RefreshToken } = db;
require("dotenv").config();
var jwt = require("jsonwebtoken");
var bcrypt = require("bcryptjs");
const LocationsModel = require("../models/Locations.model.js");
```

This code is importing various packages and libraries that are needed for the program. It is also setting up variables that will be used in the program.

The first line of code is importing the models index.js file from the models folder. The second line of code is importing the auth.config file from the config folder. The third line of code is setting a variable called API to the environment variable Emply_api. The fourth line of code is setting a variable called Roles to the db object's ROLES property. The fifth line of code is importing jwt-decode library. The sixth line of code is setting a variable called Op to db object's Sequelize property's Op property. The seventh line of code is importing axios library. The eighth line of code is importing node-fetch library. The ninth line of code is requiring dotenv package and configuring it. Finally, the tenth line of code is setting a variable called RefreshToken to db object's refreshToken property.

#### Handling errors

```js
let handleQueryError = function (err) {
  return new Response(
    JSON.stringify({
      code: 400,
      message: "Stupid Network Error",
    })
  );
};
```

This code is defining a function called handleQueryError. This function takes in an error object and returns a Response object with a 400 status code and a message.

#### Getting the user's Azure data

```js
// Get the tenant ID from the decoded token
let decoded = jwt_decode(bearer);
// Create an HTTP request to retrieve the user's profile from Azure AD
let accessTokenReqOptions = {
  method: "GET",
  headers: {
    Accept: "application/json",
    "Content-Type": "application/json; charset=utf-8",
    Authorization: `Bearer ${bearer}`,
    ConsistencyLevel: "eventual",
  },
};
let AzureData;
const url5 = `https://graph.microsoft.com/v1.0/users/${decoded.oid}`;
let response = await fetch(url5, accessTokenReqOptions);
// Create an HTTP request to retrieve the user's role from Azure AD
const url6 = `https://graph.microsoft.com/v1.0/groups/b5e910d0-4370-47a1-b834-c463618965a8/members`;
let Role = await fetch(url6, accessTokenReqOptions);
try {
  // Parse the response from Azure AD as JSON
  AzureData = await response.json();
  Role = await Role.json();
} catch (error) {
  AzureData = error;
}
// Verify that the response from Azure AD was successful
if (!response.ok) {
  res.status(400).json({ error: "something went wrong" });
  return;
}
// Filter the user's role from the response
var result = Role.value.filter((x) => x.id === AzureData.id);
// Set the user's role to the role that was found in Azure AD
if (result.length > 0) {
  Role = Roles;
} else {
  Role = Roles[0];
}
return [await AzureData, await Role];
```

This code is an asynchronous function that is used to get data from Azure. It takes two parameters, a bearer token and a response object. The code then decodes the token to get the tenant ID, creates an access token request option, and uses that to make two fetch requests. The first request is to get user data from the Microsoft Graph API, and the second request is to get group members from the same API. The code then checks if the user ID matches any of the group members, and assigns a role accordingly. Finally, it returns an array containing both the user data and role.

#### Getting users Employee data

```js
async function getEmplyData(Email, res) {
  // set up options to pass to fetch
  let accessTokenReqOptionsEmply = {
    method: "GET",
    headers: {
      Accept: "application/json",
      "Content-Type": "application/json; charset=utf-8",
    },
  };

  // create url to pass to fetch
  const url = `https://api.emply.com/v1/dialogueone/employees/find-by-name?email=${Email}&apiKey=${API}`;

  // make the request
  let Emplyresponse = await fetch(encodeURI(url), accessTokenReqOptionsEmply);

  // parse the response
  let data;
  try {
    data = await Emplyresponse.json();
  } catch (error) {
    data = error;
  }

  // if there was an error, send a 400 response
  if (!Emplyresponse.ok) {
    res.status(400).json({ error: "something went wrong" });
  } else {
    return data;
  }
}
```

This code is an asynchronous function that makes a GET request to the Emply API. It takes in an email address and a response object as parameters. It sets up the options for the fetch request, creates a URL with the email address and API key, makes the request, parses the response, and returns the data if there are no errors. If there is an error, it sends a 400 response with an error message.

#### Signing in

```js
exports.signin = async (req, res) => {
  // Azure User Data
  const data = await GetAzureData(req.body.token, res);
  let [AzureData, Roles] = data;
  let Emplydata;
  try {
    // Employee Data
    let response = await getEmplyData(data[0].mail, res);
    if (response.length === 0) {
      Emplydata = [{ id: AzureData.id, status: 200 }];
    } else {
      Emplydata = response;
    }
  } catch (error) {
    Emplydata = [{ id: AzureData.id, status: 400, error: error }];
  }
  // JWT Token
  const token = jwt.sign(
    { EmployeeID: Emplydata[0].id, User_UUID: AzureData.id, Role: Roles },
    config.secret,
    {
      expiresIn: config.jwtExpiration,
    }
  );
  // Refresh Token
  let refreshToken = await RefreshToken.createToken(AzureData);
  res.status(200).send({
    id: AzureData.id,
    username: AzureData.displayName,
    email: AzureData.mail,
    accessToken: token,
    Bearer: req.body.token,
    refreshToken: refreshToken,
    Role: Roles,
    EmployeeData: Emplydata[0],
  });
};
```

This code is a function that handles user sign-in. It first calls an external function, GetAzureData(), to get the user's data from Azure. It then calls another external function, getEmplyData(), to get the employee data associated with the user's email address. If there is no employee data associated with the email address, it creates a new object with the user's ID and a status of 200. If there is employee data associated with the email address, it stores that in the Emplydata variable.

The code then creates a JWT token using the EmployeeID, User_UUID, and Role variables from earlier. Finally, it creates a refresh token and sends back an object containing all of this information to the user.

#### Refreshing tokens

```js
// This function will be called from the /refresh route
exports.refreshToken = async (req, res) => {
  // Get the refresh token from the request body
  const { refreshToken: requestToken } = req.body;
  // If there is no refresh token, return an error
  if (requestToken == null) {
    return res.status(403).json({ message: "Refresh Token is required!" });
  }
  try {
    // Find the refresh token in the database
    let refreshToken = await RefreshToken.findOne({
      where: { token: requestToken },
    });
    // If the refresh token is not in the database, return an error
    if (!refreshToken) {
      res.status(403).json({
        message: "Your session is expired, please refresh the window!",
      });
      return;
    }
    // Verify the refresh token
    if (RefreshToken.verifyExpiration(refreshToken)) {
      // If the refresh token is expired, delete it from the database
      RefreshToken.destroy({ where: { id: refreshToken.id } });
      // Return an error
      console.log("Your session is expired, please refresh the window!");

      res.status(403).send({
        message: "Your session is expired, please refresh the window!",
      });
      return;
    }
    // If the refresh token is valid, get the user's data from the database
    const data = await GetAzureData(req.body.token);
    const Emplydata = await getEmplyData(data[0].mail, res);
    // Generate a new access token
    let [AzureData, Roles] = data;
    const newAccessToken = jwt.sign(
      { EmployeeID: Emplydata[0].id, User_UUID: AzureData.id, Role: Roles },
      config.secret,
      {
        expiresIn: config.jwtExpiration,
      }
    );
    // Return the new access token
    return res.status(200).json({
      accessToken: newAccessToken,
      refreshToken: refreshToken.token,
    });
  } catch (err) {
    return res.status(500).send({ message: err });
  }
};
```

This code is a function that is used to refresh a token. It takes the refresh token from the request body and checks if it exists in the database. If it does, it verifies that it is not expired and then gets the user's data from the database. It then generates a new access token and returns it with the refresh token in the response.

### Verification Middleware

This code exports a function called VerifyToken which takes an optional array of roles as an argument. It returns an array with a single middleware function that will be used to verify if the user is authenticated and authorized to access a certain endpoint.

The middleware function first checks if a token is present in the x-access-token header of the incoming request. If no token is found, it returns a 403 Forbidden response.

If a token is found, it is decoded using the jsonwebtoken library and the secret defined in the auth.config.js file. If the decoding fails, the middleware function returns a 401 Unauthorized response.

If the decoding succeeds, the middleware function checks if the decoded token contains a Role property. If the Role property is a string, it is converted to an array to simplify the subsequent authorization check. If the roles argument is not empty and the decoded user's roles do not match any of the allowed roles, a 401 Unauthorized response is returned.

If the user is authorized, the middleware function sets the userId property of the incoming request to the decoded user's id property and sets the res.locals.user property to the entire decoded user object. The middleware function then calls the next() function to pass control to the next middleware in the stack.

`middleware/authJwt.js`

```js
const jwt = require("jsonwebtoken");
const config = require("../config/auth.config.js");

const { TokenExpiredError } = jwt;
const catchError = (err, res) => {
  if (err instanceof TokenExpiredError) {
    return res
      .status(401)
      .send({ message: "Unauthorized! Access Token was expired!" });
  }
  return res.sendStatus(401).send({ message: "Unauthorized!" });
};

export const VerifyToken = (roles = []) => {
  if (typeof roles === "string") {
    roles = [roles];
  }
  return [
    (req, res, next) => {
      let token = req.headers["x-access-token"];
      if (!token) {
        return res.status(403).send({ message: "No token provided!" });
      }

      jwt.verify(token, config.secret, (err, decoded) => {
        if (err) {
          return catchError(err, res);
        }
        if (typeof decoded.Role === "string") {
          decoded.Role = [decoded.Role];
        }
        if (
          roles.length &&
          !decoded.Role.some((item) => roles.includes(item))
        ) {
          // user's role is not authorized
          return res.status(401).json({ message: "Unauthorized" });
        }
        req.userId = decoded.id;
        res.locals.user = decoded;
        next();
      });
    },
  ];
};
```

The middleware functions perform the following tasks:

- Check if the token exists in the request header.
- Verify the token using the secret key specified in the config.auth.js file.
- If the token is invalid or expired, return an error response.
- If the token is valid, check if the decoded token contains the required roles.
- If the user's role is not authorized, return an error response.
- If the user's role is authorized, set the decoded token's id as the userId property on the request object and attach the decoded token as the user object on the response locals.
- Call the next middleware function.

The catchError function is a helper function that returns a 401 error response with a message indicating that the user is unauthorized. The jwt-decode library is used to decode the token to obtain its payload, which contains information about the user, such as the user ID and their role(s).
