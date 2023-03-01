## Microsoft Authentication Library (MSAL)

MSAL The Microsoft Authentication Library (MSAL) enables developers to acquire tokens from the Microsoft
identity platform in order to authenticate users and access secured web APIs. It can be used to provide
secure access to Microsoft Graph, other Microsoft APIs, third-party web APIs, or your own web API.
MSAL supports many different application architectures and platforms including .NET, JavaScript, Java,
Python, Android, and iOS.

[Read more](https://learn.microsoft.com/en-us/azure/active-directory/develop/msal-overview)

### Requirements

When getting started with using Microsoft authentication in a React application, there are a few requirements that need to be met. First, you will need to have a Microsoft Azure Active Directory (AAD) tenant set up. This is where you will register your application and configure authentication settings.

Once you have an AAD tenant set up, you will need to register your React application in the Azure portal. During the registration process, you will need to specify the redirect URI for your application, which is the URL that Microsoft will redirect users to after they sign in. You will also need to specify the Microsoft Graph permissions that your application requires.

To use the MSAL library in your React application, you will need to install the @azure/msal-react package and set up an instance of the PublicClientApplication class. This class is used to authenticate users and acquire access tokens to access protected resources.

> The app is already registered in Dialogue Ones' Azure Portal

[Azure Portal Website](portal.azure.com)

Find it by navigating to here `App Registrations>Dialogue Time`

### Security tokens

A centralized identity provider is especially useful for apps that have users located around the globe who don't necessarily sign in from the enterprise's network. The Microsoft identity platform authenticates users and provides security tokens, such as access tokens, refresh tokens, and ID tokens. Security tokens allow a client application to access protected resources on a resource server.

[Read more](https://learn.microsoft.com/en-us/azure/active-directory/develop/security-tokens)

#### The use case

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

Dialogue One uses Microsoft 365 enterprise suite and services wherever they can, and seeing as every employee
have their accounts which are maintained by the service provider Sotea, the application uses MSAL to achieve SSO.

## User Authentication setup

We are using micrososfts @microsoft/mgt-msal-provider and @microsoft/mgt-react packages, you will need to have an access token from MSAL. The MgtMsalProvider component is used to provide the access tokens.

The authentication process happens in `src/App/authenticate.jsx`.

These are the packages we are using for authenticating the user. The `Login` component from [mgt-react](https://www.npmjs.com/package/@microsoft/mgt-react) works in tandem with [MSAL Providers](https://learn.microsoft.com/en-us/graph/toolkit/providers/msal2)

```js
// Imports
import React, { useEffect, useState, useCallback } from "react";
import { Login } from "@microsoft/mgt-react";
import { Providers, ProviderState } from "@microsoft/mgt";
import { Msal2Provider } from "@microsoft/mgt-msal2-provider";
import { BrowserRouter } from "react-router-dom";
import { AuthService } from "services";
import { ModalProvider } from "App/Views/Components/Modals/modalContext";
import App from "./App";
```

We have a custom hook that defines if the user is signed in or not. If the user is signed in the state is true or false.

```js
// Create a React Hook
function useIsSignedIn() {

  // Create a state variable
  const [isSignedIn, setIsSignedIn] = useState(false);

  // Create an effect to be run only once
  useEffect(() => {

    // Create a function to update the state variable
    const updateState = () => {
      const provider = Providers.globalProvider;
      setIsSignedIn(provider && provider.state === ProviderState.SignedIn);
    };

    // Add an update listener
    Providers.onProviderUpdated(updateState);

    // Call the update function to set the initial value
    updateState();

    // Remove the listener when the component is unmounted
    return () => {
      Providers.removeProviderUpdatedListener(updateState);
    };
  }, []);

  // Return the state variable
  return [isSignedIn];
}
```

This code is a React hook that checks if the user is signed in. It creates a state variable called isSignedIn and sets it to false initially. It then creates an effect that runs only once, which adds an update listener to the Providers globalProvider. The update listener calls the updateState function, which checks if the provider's state is SignedIn and updates the isSignedIn state variable accordingly. Finally, it returns the isSignedIn state variable.

Which can then be used as a stateful hook inside our component like so

```js
export default function Authenticate() {
  // ....
  const [isSignedIn] = useIsSignedIn();
  // ...
}
```

This code creates a function called Authenticate that is exported as the default. The function uses the useIsSignedIn hook to set a variable called isSignedIn. This variable can then be used in the body of the function to determine if a user is signed in or not.

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
