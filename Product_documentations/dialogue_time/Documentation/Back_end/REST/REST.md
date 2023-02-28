> # REST

# Restful routes

The RESTful routes in the application are designed to map HTTP verbs (GET, POST, PUT, DELETE, PATCH) to the corresponding controllers that handle CRUD operations. These routes are created using the Express package and are structured according to the RESTful naming convention.

The naming convention follows a hierarchical approach where the highest-level name in the route represents the table in which the resource exists. In certain cases, the route name may represent specific business functionality, such as salary processes.

For instance, a RESTful route for the "users" table could be "/api/users" and the corresponding HTTP verb would determine the CRUD operation performed on the "users" table. Similarly, a RESTful route for a salary process functionality could be "/api/salary/process" and the corresponding HTTP verb would determine the action performed on the salary process.

The RESTful routes in the application follow a standard naming convention and are structured to provide a clear mapping between the HTTP verbs and their corresponding controllers for efficient CRUD operations.

<hr>
Sums hours logged on specific projects between two dates <br>

```crud
https://api.dialogueone.dk/Hours/project/{project}/start/{start}/end/{end}/sum/hours
```

<hr>

```js
module.exports = (app, VerifyToken) => {
  router.get(
    `/Hours/project/:project/start/:start/end/:end/sum/hours`,
    VerifyToken(),
    hours.sum_by_Month_and_project
  );
  app.use("/api", router);
};
```

The development of the RESTful API was facilitated by utilizing the Swagger library, which provides a comprehensive set of tools for API design, development, documentation, testing, governance, and monitoring. In particular, the automatic API documentation features offered by Swagger have been extremely useful in creating a web-based interface portal that enables developers to interact with the API. While the documentation portal is still being developed, it currently offers valuable information for developers to access and interact with the API.
