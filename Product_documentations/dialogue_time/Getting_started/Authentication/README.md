# Authentication

For user authentication on Dialogue Time, the requirement is to utilize SSO. The original Dialogue Time was
created using a traditional user management system, saving personal information inside a database and hashing
their passwords. Having an infrastructure for password recovery and manual recovery was sometimes needed.

Using SSO I would effectively increase security by utilizing double authentication. Eliminate the risks of the
consultants’ passwords being compromised due to SQL Injection or a breach and eliminate the administrative
overhead of user management in more than one system.

## Setup

This is a module in JavaScript that exports an AuthService class with methods for authentication and user registration.

The import statement is used to import the http module from the ../Common_service/rest_http_common file and the TokenService module from the ./token.service file.

The AuthService class has four methods:

- login(parameters) sends a POST request to the /auth/signin endpoint with parameters data and sets the user token in the TokenService. Returns the response data.
- logout() removes the user token from the TokenService.
- register(username, email, password) sends a POST request to the /auth/signup endpoint with username, email, and password data.
- getCurrentUser() returns the user token from the TokenService.

The export default statement exports a new instance of the AuthService class as the default export of this module.

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
