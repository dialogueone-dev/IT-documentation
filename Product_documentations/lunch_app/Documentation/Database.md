# Database

The application uses MySQL as the database management system. The database connection is established using the PDO (PHP Data Objects) extension, which provides a lightweight and consistent interface for accessing databases in PHP.

The database connection code is defined in a try-catch block that catches any exceptions thrown during the connection process. The PDO constructor takes several arguments, including the host, database name, username, password, and options. In this case, the host is set to localhost, the database name is set to dialogueone_com_db_lunch_app, the username is set to root, and the password is set to Sp.arK2021. The options array includes several settings, including the error mode, default fetch mode, and initialization command.

Here's an example of the database connection code:

```js
try {
  $sDatabaseUserName = '{user}';
  $sDatabasePassword = '{password}';
  $sDatabaseConnection = "mysql:host=localhost;dbname=dialogueone_com_db_lunch_app; charset=utf8mb4;";
  $aDatabaseOptions = array(
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_OBJ, // Array with object
    PDO::MYSQL_ATTR_INIT_COMMAND => "SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''))"
  );
  $db = new PDO( $sDatabaseConnection, $sDatabaseUserName, $sDatabasePassword, $aDatabaseOptions );
} catch(PDOException $e) {
  echo $e;
  exit();
}
```

Once the database connection is established, the application can use PDO to execute SQL queries and interact with the database. The functionality is mostly created as procedures within phpMyAdmin and stored in the database. The procedures can be called from within the application using PDO, allowing the application to perform complex database operations with ease.

## Procedures

### Retrieve All Purchases Between Two Given Date Times

The procedure is designed to retrieve all purchases made between two given date times. It takes two parameters, var_date_begin and var_date_end, which specify the start and end dates for the purchase report. The procedure uses several joins to retrieve information from the purchase, purchase_items, and lunch_items tables.

Here's an example of the procedure code:

```sql
BEGIN

SELECT p.purchase_number as "Purchase Number", p.user_uuid as "User ID", li.lunch_item_name as "Item name", pi.lunch_item as "Item ID", amount as "Amount", price as "Price", p.date_purchaged as "Date Purchased"
FROM purchase as p
LEFT JOIN purchase_items as pi
ON p.purchase_number = pi.purchase_number
LEFT JOIN lunch_items as li
ON pi.lunch_item = li.unique_id
WHERE p.date_purchaged BETWEEN var_date_begin AND var_date_end;

END
```

The procedure selects several columns from the `purchase`, `purchase_items`, and `lunch_items` tables, including the purchase number, user ID, item name, item ID, amount, price, and date purchased. The `LEFT JOIN` clauses join the `purchase_items` and `lunch_items` tables to the `purchase table`, allowing the procedure to retrieve information about the items purchased. The `WHERE` clause restricts the results to purchases made between the start and end dates specified by the `var_date_begin` and `var_date_end` parameters.

This procedure can be called from within the application using PDO, allowing the application to generate purchase reports with ease.

### Retrieve a User's Purchases Between a Given Time

The procedure is designed to retrieve a user's purchases between a given time. It takes three parameters, `var_date_begin`, `var_date_end`, and `var_user_uuid`, which specify the start and end dates for the purchase report, as well as the user ID of the user whose purchases should be retrieved. The procedure uses several joins to retrieve information from the purchase_items and lunch_items tables.

Here's an example of the procedure code:

```sql

BEGIN
  SELECT li.lunch_item_name as lunch_name, a.lunch_item as ItemID, sum(a.amount) as amount, p.user_uuid as userID
  FROM purchase_items as a
  LEFT JOIN lunch_items  as li
  ON li.unique_id = a.lunch_item
  LEFT JOIN purchase as p
  ON p.purchase_number = a.purchase_number
  WHERE p.date_purchaged BETWEEN var_date_begin AND var_date_end AND p.user_uuid = var_user_uuid
  GROUP BY a.lunch_item, p.user_uuid;
END


```

The procedure selects several columns from the purchase_items and lunch_items tables, including the lunch item name, item ID, amount, and user ID. The `LEFT JOIN` clauses join the `purchase_items` and lunch_items tables to the purchase table, allowing the procedure to retrieve information about the items purchased. The `WHERE` clause restricts the results to purchases made between the start and end dates specified by the `var_date_begin` and `var_date_end` parameters, as well as the user ID specified by the `var_user_uuid` parameter. The `GROUP BY` clause groups the results by lunch item and user ID.

This procedure can be called from within the application using PDO, allowing the application to generate purchase reports for individual users with ease.

### Retrieve All Purchases Between Two Given Date Times for a Specific User

The procedure is similar to the previous procedure, but adds an additional condition to retrieve purchases made by a specific user. It takes three parameters, `var_date_begin`, `var_date_end`, and `var_user_uuid`, which specify the start and end dates for the purchase report, as well as the user ID of the user whose purchases should be retrieved. The procedure uses several joins to retrieve information from the `purchase`, `purchase_items`, and `lunch_items` tables.

Here's an example of the procedure code:

```sql
BEGIN

SELECT p.purchase_number, p.user_uuid, li.lunch_item_name as lunch_item_name, pi.lunch_item, amount, price, p.date_purchaged
FROM purchase as p
LEFT JOIN purchase_items as pi
ON p.purchase_number = pi.purchase_number
LEFT JOIN lunch_items as li
ON pi.lunch_item = li.unique_id
WHERE p.date_purchaged BETWEEN var_date_begin AND var_date_end
AND p.user_uuid = var_user_uuid;

END

```

The procedure selects several columns from the `purchase`, `purchase_items`, and lunch_items tables, including the purchase number, user ID, item name, item ID, amount, price, and date purchased. The `LEFT JOIN` clauses join the `purchase_items` and `lunch_items` tables to the purchase table, allowing the procedure to retrieve information about the items purchased. The `WHERE` clause restricts the results to purchases made between the start and end dates specified by the `var_date_begin` and `var_date_end` parameters, as well as purchases made by the user specified by the `var_user_uuid` parameter.

This procedure can be called from within the application using PDO, allowing the application to generate purchase reports for individual users within a specific time frame
