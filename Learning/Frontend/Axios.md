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

```js
axios.interceptors.response.use(
  function (response) {
    return response;
  },
  function (error) {
    if (error.response.status === 401) {
      // Handle 401 error
    }
    return Promise.reject(error);
  }
);
```

In the above example, we are using the axios.interceptors.response.use() method to handle HTTP errors with a status code of 401. If a 401 error occurs, the code inside the if statement will be executed to handle the error.

By using interceptors, you can easily add custom behavior to your Axios requests and responses, making your code more flexible and powerful.
