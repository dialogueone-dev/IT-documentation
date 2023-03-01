> # Backend Architecture Overview

The decision to use Node.js for the back-end of the application offers benefits such as access to similar libraries and frameworks used in the front-end, leading to consistency in development. It also simplifies the overall technology stack by using a single programming language, which can make hiring new developers easier.

## Service oriented architecture

The back-end application is built using the SOA (Service Oriented Architecture) architecture in an OOP (Object Oriented Programming) manner. To achieve this, the developer combined the ORM (Object Relational Model) library Sequalize and the web application library Express to create a functional REST API (Application Programming Interface). The application uses Models to represent database Tables, Express API routes to listen for HTTP calls, and Controllers with methods that are instantiated when those calls are made. The application is designed with a modular structure, which can be built upon quickly. Although the intention was to build a strict SOA architecture, the application currently needs refactoring, as most of the computation resides within the Controllers.

![Rest ERD](../../../../../images/Rest%20app.png "Rest ERD")


### Models

The application utilizes the Sequalize ORM library to simplify database operations and reduce complexity between the database and programming. Sequalize supports multiple database management systems, including PostgreSQL, MySQL, MariaDB, SQLite and SQL Server. The MySQL version was chosen to maintain consistency with the previous database. The library provides various functionalities that simplify CRUD operations and remove complexities typically found in SQL programming.

Here's an example model using Sequalize for a User table with id, username, email, and password columns:

```js
const { Model, DataTypes } = require("sequelize");
const sequelize = require("../config/database");

class User extends Model {}

User.init(
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    username: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true,
    },
    email: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true,
      validate: {
        isEmail: true,
      },
    },
    password: {
      type: DataTypes.STRING,
      allowNull: false,
    },
  },
  {
    sequelize,
    modelName: "user",
  }
);

module.exports = User;
```

This model defines a User table with columns for id, username, email, and password. The DataTypes from Sequalize are used to specify the type of data for each column. The Model class from Sequalize is extended by our User class, and then the init() method is called with the model's attributes and options. Finally, the model is exported for use in other parts of the application

### Controllers

API controllers are responsible for handling the request-response cycle of HTTP calls, receiving or sending data back to the client. While web API controllers serve many clients, MVC controllers are intended to serve only their client. Although there are libraries for constructing controllers, at the core, a controller is a simple method that returns something. Therefore, when utilizing Sequalize ORM features, using a library is not necessary. Unlike traditional SOA that have service scripts defining global helper functions and business logic, Dialogue Time relies on Sequalize and middleware functionalities to handle a wide variety of business logic. However, in retrospect, some of the controllers have become complex and may rely on others to complete their tasks, so refactoring may be necessary.

Here's an example of how to find a user using Sequalize:

```js
exports.find_user = async (req, res) => {
  // #swagger.tags = ['Users']
  // #swagger.description = 'Find a user by their ID'

  const user = await User.findOne({
    where: {
      id: req.params.id,
    },
  });

  if (user) {
    res.send(user);
  } else {
    res.status(404).send({ error: "User not found" });
  }
};
```

Sequelize ORM library offers a variety of functionalities that simplify CRUD operations and make SQL programming less complex. Additionally, the library allows instantiating methods to models, enabling reusability of code, such as finding the balance for accounts. Sequelize also provides a validation tool that helps to prevent data inconsistency, for example, ensuring that hours are not logged in a previous or upcoming salary period. In development mode, the database can be synchronized using the synchronization method, which ensures that the database stays in sync with the models and their relations to each other. If Sequelize detects any changes in the models, the tables are altered automatically. Once ready for production, the changes can be easily migrated.

```js
const User = sequelize.define("User", {
  name: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  email: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true,
    validate: {
      isEmail: true,
    },
  },
  password: {
    type: DataTypes.STRING,
    allowNull: false,
  },
});

User.beforeCreate((user, options) => {
  if (!user.email || !validator.isEmail(user.email)) {
    throw new Error("Invalid email address");
  }
});
```

In this example, we define a User model with name, email, and password fields. The email field has a built-in validation rule isEmail to ensure that it is a valid email address.

We then define a beforeCreate hook for the User model. This hook is called automatically by Sequalize before a new user is created in the database. In this hook, we check if the email address provided by the user is valid using a third-party library called validator. If the email address is invalid, we throw an error to prevent the user from being created.

You can add more hooks for other validations or business logic as needed.

### Advantages

Using ORM include simplification of development through automating object-to-table and table-to-object conversions, optimized and easier maintenance, cost reduction due to less code compared to embedded SQL and handwritten stored procedures, and reduced risk of SQL injection. Additionally, models only need to be written once, eliminating repetition and providing a single reference point for all code.

### Disadvantages

Using ORM can include hindrance if a developer does not understand the database layer, potential performance issues with complex queries if not implemented correctly, and the need for developers to learn and maintain ORM knowledge.
