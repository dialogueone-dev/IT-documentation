> # Microsoft Authentication Library (MSAL)

MSAL The Microsoft Authentication Library (MSAL) enables developers to acquire tokens from the Microsoft
identity platform in order to authenticate users and access secured web APIs. It can be used to provide
secure access to Microsoft Graph, other Microsoft APIs, third-party web APIs, or your own web API.
MSAL supports many different application architectures and platforms including .NET, JavaScript, Java,
Python, Android, and iOS.

[Read more](https://learn.microsoft.com/en-us/azure/active-directory/develop/msal-overview)

# Security tokens

A centralized identity provider is especially useful for apps that have users located around the globe who don't necessarily sign in from the enterprise's network. The Microsoft identity platform authenticates users and provides security tokens, such as access tokens, refresh tokens, and ID tokens. Security tokens allow a client application to access protected resources on a resource server.

[Read more](https://learn.microsoft.com/en-us/azure/active-directory/develop/security-tokens)

## The use case

Dialogue One benefits directly from using Microsoft’s MSAL services, which are used to create a
SSO authentication method for users using the MS login details. In addition, the other SaaS products also offer
SSO using Microsoft Graph connections which creates a unified experience for consultants using the different
provisioned products.
The highlights of these benefits are:

- Access to user resources.
- Allows displaying user specific information like, calendar, availability etc.
- Eliminating redundancy by unifying the user management system.
- Integrating SSO.

## SSO

Dialogue One utilizes the Microsoft 365 enterprise suite and services extensively, and as every employee has a meticulously maintained account by the service provider Sotea, an integration method utilizing MSAL allows for Single Sign-On (SSO) capability. By leveraging Microsoft's MGT React components and MSAL providers, the application was transformed into an SSO compatible app. MSAL offers token acquisition from various application types, including web applications, web APIs, single-page apps (JavaScript), mobile and native applications, and daemons and server-side applications.

## Setup

<h3> Single Page application setup React JS</h3>

Read the [documentation](https://learn.microsoft.com/en-us/azure/active-directory/develop/index-spa) for a deeper understanding of the authentication flow.

Read the React [tutorial](https://learn.microsoft.com/en-us/azure/active-directory/develop/tutorial-v2-react) to understand how to use it.

[NPM](https://www.npmjs.com/package/@azure/msal-react) package.

The authentication flow is made in `src\App\authenticate.jsx`, the example below shows how to configure it.

```js
import { Providers, ProviderState } from "@microsoft/mgt";
import { Msal2Provider } from "@microsoft/mgt-msal2-provider";
// Set the scopes to what you want to access from Microsoft Graph
const Scopes = [
...
"User.Read",
"User.Read.All",
...
// More scopes can be added for what you need.
];
// Configure the way the connection protocol
const config = {
redirectUri: `${window.location.origin}`,
authority:
"https://login.microsoftonline.com/dd9fe8e0-ee42-4b62-b9a4-b796431bfdfe",
cache: {
cacheLocation: "localStorage",
storeAuthStateInCookie: true,
},
scopes: Scopes,
cacheLocation: "localStorage",
storeAuthStateInCookie: true,
clientId: "380f1112-8e95-4f6e-bd18-9a3e44ca9272",
};
Providers.globalProvider = new Msal2Provider(config);
```
