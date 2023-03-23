# Axios

## What is Axios

Axios is a popular JavaScript library that is used for making HTTP requests from web browsers or Node.js applications. It provides a simple and consistent API for sending and receiving data from a server using the HTTP protocol.

Axios is often used in front-end development with React.js applications to communicate with a server-side API or other backend services. Axios can be used for making HTTP requests to retrieve data, create or update resources, and handle errors and exceptions.

Some of the key features of Axios include:

1. **Promise-based API:** Axios uses Promises to handle asynchronous requests, making it easy to manage complex chains of requests and responses.

2. **Interceptor support:** Axios supports interceptors, which allow developers to intercept and modify HTTP requests and responses before they are sent or received.

3. **Cross-platform support:** Axios can be used in both browser-based and server-side JavaScript environments, including Node.js.

4. **JSON data handling:** Axios can handle JSON data automatically, making it easy to send and receive data in a standardized format.

Axios is often used in combination with other React.js libraries and frameworks, such as Redux or React Router, to create powerful and scalable web applications.

## Installing Axios

Before using Axios in your React.js project, you need to install it as a dependency. You can do this by running the following command in your terminal:

```js
npm install axios
```

## Making GET Requests with Axios

To make a GET request with Axios in a React.js application, you can use the following syntax:

```js
import axios from "axios";

axios
  .get("https://jsonplaceholder.typicode.com/posts")
  .then((response) => {
    console.log(response.data);
  })
  .catch((error) => {
    console.log(error);
  });
```

In the above example, we are making a GET request to the JSONPlaceholder API to retrieve a list of posts. The .then() method is used to handle the response data, while the .catch() method is used to handle any errors that may occur.

## Making POST Requests with Axios

To make a POST request with Axios in a React.js application, you can use the following syntax:

```js
import axios from "axios";

axios
  .post("https://jsonplaceholder.typicode.com/posts", {
    title: "Hello World",
    body: "This is a test post",
    userId: 1,
  })
  .then((response) => {
    console.log(response.data);
  })
  .catch((error) => {
    console.log(error);
  });
```

In the above example, we are making a POST request to the JSONPlaceholder API to create a new post. We are passing an object as the second argument to the axios.post() method, which contains the data we want to send to the server.

## Using Interceptors with Axios

Axios provides a powerful and flexible way to intercept HTTP requests and responses. Interceptors can be used to add headers, modify requests, handle errors, and perform other operations on HTTP requests and responses.

To use an interceptor in your Axios requests, you can use the axios.interceptors property. For example, to add a header to all of your requests, you can use the following code:

```js
import axios from "axios";

axios.interceptors.request.use(function (config) {
  config.headers.Authorization = "Bearer " + localStorage.getItem("token");
  return config;
});
```

In the above example, we are using the axios.interceptors.request.use() method to add an Authorization header to all of our requests. The header value is retrieved from local storage, but could be retrieved from a cookie or other source.

Interceptors can also be used to handle errors and modify responses. For example, to handle HTTP errors with a specific status code, you can use the following code:

## Axios used in Dialogue Time

### Axios instance

```js
// File: services/http-common.js
import axios from "axios";
const instance = axios.create({
  baseURL: "https://api-dev.dialogueone.com/api",
  headers: {
    "Content-type": "application/json",
  },
});
export default instance;
```

### Request Interceptor

The request interceptor is used to intercept outgoing requests before they are sent to the API. It adds a set of headers to the request, including an access token, user ID, and a custom MSBearerToken header. This allows the API to authenticate the user and validate the token before processing the request.

```js
// Request interceptor
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

### Response Interceptor

The response interceptor is used to intercept incoming responses before they are processed by the application. It checks if the response has a 401 status code, which indicates an expired access token. If the access token is expired, the interceptor sends a request to the /auth/refreshtoken endpoint of the API to refresh the access token. Once the new access token is obtained, it is stored locally and used to update the original request with a new x-access-token header. The original request is then resent with the new header.

If the refresh token request fails, the interceptor rejects the promise with the error response. If the original request was not a login request, the interceptor will retry the request with the new access token header. If the original request was a login request, the interceptor rejects the promise and returns the error response to the application.

```js
// Response interceptor
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
```

### Using Instances in data service classes

In the following example, an instance of the class TaskDataService is created. This class uses the Axios HTTP methods to make API calls to the back-end corresponding to the Tasks Model. The tasks data is then displayed on the front-end to show what tasks were worked on when logging hours. Additionally, some data services call more complex API endpoints that perform specific business logic.

```js
// File: services/TaskDataService.js
import http from "./http-common";
class TaskDataService {
  async getAll() {
    const response = await http.get(`/Task`);
    return response.data;
  }
  async get(id) {
    const response = await http.get(`/Task/${id}`);
    return response.data;
  }
  async create(data) {
    const response = await http.post("/Task", data);
    return response.data;
  }
  async update(id, data) {
    const response = await http.put(`/Task/${id}`, data);
    return response.data;
  }
  async delete(id) {
    const response = await http.delete(`/Task/${id}`);
    return response.data;
  }
}
export default new TaskDataService();
```
