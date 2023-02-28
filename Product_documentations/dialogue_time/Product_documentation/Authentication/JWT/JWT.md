> # JWT Tokens

JSON Web Token (JWT) is an open standard (RFC 7519) that defines a compact and self-contained way for securely transmitting information between parties as a JSON object. This information can be verified and trusted because it is digitally signed. JWTs can be signed using a secret (with the HMAC algorithm) or a public/private key pair using RSA or ECDSA.

[Read more](https://jwt.io/introduction)

# The use case

Similarly to the MSAL Bearer token, JWT tokens work the same way, passing encrypted user information
between the client and the server. The reason to add JWT tokens to the application a well is to validate the user against the database. Also to define role-based access to the data and services.
Furthermore, although roles and titles exist in a user Microsoft’s identity, accessible in the MSAL bearer token,
creating a separation of concern is vital since these roles and titles correlate to resources and services inside
Microsoft, not Dialogue Time.

“Once the user is logged in, each subsequent request will include the JWT, allowing the user to access routes,
services, and resources that are permitted with that token”.

## Signing

Using a secret key stored in the web-server environment and a JSON object with information about the user
(roles etc.), the app generates an encoded JWT token and a refresh token, which it stores in the database for later
reference. The token is then sent to the client and will be used for any subsequent requests.

## Roles

The web server currently has two roles: admin and user. Personal information about users is not stored in the database. Instead, the server accesses information from Microsoft Graph using the MSAL bearer token to fetch information about a designated group for admins. If the user is validated with MSAL and is part of the organization, the server checks if they are part of the admin group. If they are, they receive an admin role; otherwise, they are assigned a regular user role.

## Verifying

An authentication Middleware has been created to verify the user before executing the controller. The Middleware function VerifyToken() is called without any parameters, but the role associated with admins is passed as a parameter.

```js
1 // File: api/app/routes/hours.routes.js
2 router.delete("/Hours/:id", VerifyToken(Roles[1]), hours.delete);
```

Figure 4.19: an example of a route with a role based permission associated with admins.

In figure 4.19 above, the roles are passed in as an array, meaning multiple roles could be associated with a
resource. If no role is passed as a parameter, the resource should be free for all authenticated users. The
Middleware function starts validating the parameters. Then it checks if a token was provided. After decoding the
token, it sees the information about the user (role etc.) and verifies that the user has the necessary permissions to
access the resource.

“The middleware authentication script is located in the API folder under api/middleware/authJwt.js”

## Refresh Tokens

The system includes a solution where JWT tokens live as long as the MSAL token due to the short lifespan of MSAL tokens. This is because the MSAL token is stored in cookies and does not refresh automatically. To avoid resource fetching errors caused by expired tokens, the JWT token expires after one hour. The front-end application handles expired tokens with a retry catch method using interceptors. The method makes a call to create new JWT and MSAL tokens by utilizing the previously explained JWT refresh tokens stored in the local storage. Upon receiving a refresh token, the server compares it to the stored tokens in the database with the MSAL user ID as the connection. If the token is found and not expired, the user's information is decoded from the refresh token, creating a new token. Note that while the interceptor method works, it may not be optimal, and refactoring it by moving the logic into the rejection handler is recommended.

“The interceptor function can be found in the common service folder
src/services/Common_service/rest_http_common.js”

# Setup

`src\services\REST_service\auth.service.js`

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

`app/routes/auth.routes.js`

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

`app/models/RefreshToken.model.js`

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
let handleQueryError = function (err) {
  return new Response(
    JSON.stringify({
      code: 400,
      message: "Stupid Network Error",
    })
  );
};
async function GetAzureData(bearer, res) {
  let decoded = jwt_decode(bearer); //Get the tenant ID from the decoded token
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

  const url6 = `https://graph.microsoft.com/v1.0/groups/b5e910d0-4370-47a1-b834-c463618965a8/members`;
  let Role = await fetch(url6, accessTokenReqOptions);
  try {
    AzureData = await response.json();
    Role = await Role.json();
  } catch (error) {
    AzureData = error;
  }
  if (!response.ok) {
    res.status(400).json({ error: "something went wrong" });
    return;
  }
  var result = Role.value.filter((x) => x.id === AzureData.id);
  if (result.length > 0) {
    Role = Roles;
  } else {
    Role = Roles[0];
  }
  return [await AzureData, await Role];
}

async function getEmplyData(Email, res) {
  let accessTokenReqOptionsEmply = {
    method: "GET",
    headers: {
      Accept: "application/json",
      "Content-Type": "application/json; charset=utf-8",
    },
  };
  const url = `https://api.emply.com/v1/dialogueone/employees/find-by-name?email=${Email}&apiKey=${API}`;
  let Emplyresponse = await fetch(encodeURI(url), accessTokenReqOptionsEmply);
  let data;
  try {
    data = await Emplyresponse.json();
  } catch (error) {
    data = error;
  }
  if (!Emplyresponse.ok) {
    res.status(400).json({ error: "something went wrong" });
  } else {
    return data;
  }
}

exports.signin = async (req, res) => {
  const data = await GetAzureData(req.body.token, res);
  let [AzureData, Roles] = data;
  let Emplydata;
  try {
    let response = await getEmplyData(data[0].mail, res);
    if (response.length === 0) {
      Emplydata = [{ id: AzureData.id, status: 200 }];
    } else {
      Emplydata = response;
    }
  } catch (error) {
    Emplydata = [{ id: AzureData.id, status: 400, error: error }];
  }
  const token = jwt.sign(
    { EmployeeID: Emplydata[0].id, User_UUID: AzureData.id, Role: Roles },
    config.secret,
    {
      expiresIn: config.jwtExpiration,
    }
  );
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

exports.refreshToken = async (req, res) => {
  const { refreshToken: requestToken } = req.body;
  if (requestToken == null) {
    return res.status(403).json({ message: "Refresh Token is required!" });
  }
  try {
    let refreshToken = await RefreshToken.findOne({
      where: { token: requestToken },
    });
    if (!refreshToken) {
      res.status(403).json({
        message: "Your session is expired, please refresh the window!",
      });
      return;
    }
    if (RefreshToken.verifyExpiration(refreshToken)) {
      RefreshToken.destroy({ where: { id: refreshToken.id } });
      console.log("Your session is expired, please refresh the window!");

      res.status(403).send({
        message: "Your session is expired, please refresh the window!",
      });
      return;
    }
    const data = await GetAzureData(req.body.token);
    const Emplydata = await getEmplyData(data[0].mail, res);

    let [AzureData, Roles] = data;
    const newAccessToken = jwt.sign(
      { EmployeeID: Emplydata[0].id, User_UUID: AzureData.id, Role: Roles },
      config.secret,
      {
        expiresIn: config.jwtExpiration,
      }
    );
    return res.status(200).json({
      accessToken: newAccessToken,
      refreshToken: refreshToken.token,
    });
  } catch (err) {
    return res.status(500).send({ message: err });
  }
};
```

`src\services\Common_service\rest_http_common.js`

```js
import axios from "axios";
import { Providers } from "@microsoft/mgt";
import TokenService from "services/REST_service/token.service";

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

const instance = axios.create({
  baseURL: "https://api-v2.dialogueone.com/api",
  headers: {
    "Content-type": "application/json",
  },
});

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
