> # Custom Routing System

The application uses a custom routing system to handle all incoming requests dynamically. The routing system is defined in the router.php file, which contains several functions for handling different types of HTTP requests, including get(), post(), put(), patch(), delete(), and any(). These functions take two arguments: the route and the path to the file that handles the request.

Each route is defined using the get(), post(), or other request-specific function, followed by the route and the path to the file that handles the request. For example, the route /add-products is handled by the add_products.php file using the get() function:

```php
get('/add-products', 'views/add_products.php');
```

Routes can include variables by specifying a parameter name in the route using the $ symbol. For example, the route /food/images/$id includes a parameter named $id:

```php
get('/food/images/$id', 'api/controllers/get_food_images.php');
```

When a request comes in, the routing system compares the request URL to the defined routes and includes the appropriate file if there is a match. If the route includes a parameter, the value of the parameter is passed as a variable to the included file.

The router.php file also includes several utility functions, including route(), which is called by the request-specific functions to handle the route, and is_csrf_valid(), which checks whether a CSRF token is present and valid for the request.

The API folder contains controllers, routes, and services that handle API requests. These files are organized by their respective HTTP request method, and the corresponding function in the router.php file is used to route these requests.

By using a custom routing system, the application can handle all incoming requests dynamically, making it easy to add new routes and update existing ones.
