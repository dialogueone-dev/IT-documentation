> # JWT Tokens

JSON Web Token (JWT) is an open standard (RFC 7519) that defines a compact and self-contained way for securely transmitting information between parties as a JSON object. This information can be verified and trusted because it is digitally signed. JWTs can be signed using a secret (with the HMAC algorithm) or a public/private key pair using RSA or ECDSA.

[Read more](https://jwt.io/introduction)

### The use case

To provide validation and role-based access to the data and services, JWT tokens are used in a similar manner as the MSAL Bearer token. The purpose of the JWT token is to authenticate the user against the database and to assign access to certain resources and services based on their role. Although roles and titles can be accessed through Microsoft's identity system, it is important to separate this information from Dialogue Time's resources and services.

Once the user is authenticated, subsequent requests will include the JWT token, which grants access to permitted routes, services, and resources.

### Signing

Using a secret key stored in the web-server environment and a JSON object with information about the user
(roles etc.), the app generates an encoded JWT token and a refresh token, which it stores in the database for later
reference. The token is then sent to the client and will be used for any subsequent requests.

### Roles

The web server currently has two roles: admin and user. Information regarding the organization can be accessed using Microsoft Graph, as explained in section 3.1. Since user information is not stored in the database, a solution was created to call Microsoft Graph using the MSAL bearer token to retrieve information about a Microsoft group designated for admins. By validating the user with MSAL and verifying their membership in the organization's admin group, the application can assign an admin role. Otherwise, the user is assigned a regular user role.

### Verifying

An authentication middleware was developed to verify the user, and it is called before executing the controller. The VerifyToken() function does not take any parameters. However, as seen in the example below, the role associated with admins is passed as a parameter.

```js
1 // File: api/app/routes/hours.routes.js
2 router.delete("/Hours/:id", VerifyToken(Roles[1]), hours.delete);
```

The application uses a role-based access control system, where multiple roles can be associated with a resource using an array. If no role is specified, the resource is available to all authenticated users. The authentication middleware function validates the parameters and checks for the presence of a token. After decoding the token, it verifies that the user has the required permissions to access the resource based on their role information.

“The middleware authentication script is located in the API folder under api/middleware/authJwt.js”

### Refresh Tokens

A solution was implemented to ensure that JWT tokens live as long as MSAL tokens, as MSAL tokens are short-lived and stored in cookies without automatic refresh. To prevent the application from fetching resources from an expired token, the JWT token was set to expire after one hour. If a call is rejected with an expired token, the front-end application handles it with a retry catch method using interceptors, which make a call to create new JWT and MSAL tokens. The method uses the JWT refresh tokens stored in the client's local storage, which are compared to the tokens stored in the database using the MSAL user ID as the connection. If a token is not found, there will be an error. The tokens also have a 24-hour expiry limit. If a token is found and not expired, information about the user is decoded from the refresh token to create a new token. The interceptor function is located in the common service folder. Note that the interceptor method needs refactoring, as it currently calls for a new MSAL token each time a request is made. Moving that logic into the rejection handler would be more optimal.

`src/services/Common_service/rest_http_common.js`
