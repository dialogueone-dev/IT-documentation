# Axios

Axios is a popular HTTP client that can work with both browsers and Node.js. It uses a promise-based system to simplify code and allows developers to create a pre-configured class instance with built-in methods that correspond to various HTTP method types. These methods are utilized in each data service class to make API requests. Axios also includes interceptors that execute with every request or response, which I incorporated into the Axios instance for additional functionality.

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

Example of an Axios instance

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

Example of a data service class, that performs CRUD operations on the Task Model.
