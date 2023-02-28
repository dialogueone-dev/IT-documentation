> # Front-end architecture

React is a framework that doesn't strictly follow the MVC architecture, but developers can structure their code to follow it. React doesn't enforce a particular architecture, but it's important to design the application in a way that's beneficial for both the development team and the application's performance. Although the back-end Controllers and Models are responsible for managing data in the application, React's View component is the front-end application.

## Data services

To explain the front-end architecture, it's important to understand how the application retrieves data from the back-end. The data is retrieved through a series of Classes that are instantiated as needed. Each Class has a series of methods that perform API calls to the back-end, which then performs CRUD operations. This approach makes the front-end an API first application that is detached from the actual Models and Controllers. Each data service is designed to correspond to a specific Model, integration feature, or business functionality.

## Stateful Component Design

To effectively explain the front-end architecture, the writer first describes how the application retrieves data from the back-end. They created a series of classes that act as data services, which are instantiated when needed. Each class has methods that perform API calls to the back-end for CRUD operations. Therefore, the front-end is an API-first application that is detached from the back-end's Models and Controllers. Each data service corresponds to a specific feature or business functionality.

The React application was written using Hooks, which allows for writing decoupled functional components instead of convoluted class-based components. Passing props down the component tree is a core feature of React, and because each functional component uses a local state, it's important to consider the data's lifecycle and which components need that data. The writer addresses non-persistent data using the `useState`, `useCallback`, and `useEffect` Hooks with the data service.

For example, they describe a component that fetches user logs from the master log and displays them as actions that users have performed in the system. The component is designed with isolation in mind but will always fetch new data from the master log when it renders.

```js
// File: src/App/Views/Users/Profile/logs.jsx
import { useEffect, useCallback, useState } from "react";
import OrdersOverview from "App/Views/Components/Material_ui/OrdersOverview";
import { LogsDataService } from "services";
export default function UserLogs() {
  // Define the state where Logs will exist
  const [Logs, setLogs] = useState();
  // UseCallback is remembered if the component is re-rendered
  const GetLogs = useCallback(async () => {
    // Fetch newest log with a limit of 5
    const logs = await LogsDataService.GetLogsForUser(5);
    // Set the Logs state with the data returned from the fetch function
    setLogs(logs.data);
  }, [APIState]);

  // useEffect is triggered on render since it has no dependencies.
  useEffect(() => {
    GetLogs();
  }, []);
  return (
    <>
      // Conditionally render child component if Logs are not empty
      {Logs && <OrdersOverview Logs={Logs} />}
    </>
  );
}
```

Example on how to call data services inside a component and pass data down to child components.

## Flux

The Flux design pattern, introduced by Facebook (the creators of React), promotes a single source of truth, the Stores. These Stores subscribe to dispatchers that are triggered by actions. Once an action triggers a dispatch, the store is updated accordingly, and any components that subscribe to a store state will re-render automatically.

Using this pattern is beneficial when designing a React app as it simplifies the process of adding reusable components to a large codebase by eliminating the complexities of passing props. Furthermore, it can address concerns regarding persistent data lifecycle and management by creating a global store.

### Custom Store (Redux)

Redux is a popular toolkit for React that manages application states and is inspired by the Flux pattern. In the context of the previous concerns, Redux was used to centralize data and logic behind a persistent global state. To avoid excessive reliance on external packages, a custom global store component called "GlobalState" was created using React's built-in createContext and useReducer Hooks. By wrapping the "GlobalState" provider around the highest level component in the app, a unidirectional data flow through the component tree was established, enabling the creation of a global store.

```js
import React from "react";
import ReactDOM from "react-dom";
import Authenticate from "./authenticate";
// Import the StoreProvider functional component
import { StoreProvider } from "./context/store.js";

ReactDOM.render(
  <React.StrictMode>
    // Wrapp the functional component around the application
    <StoreProvider>
      <Authenticate />
    </StoreProvider>
  </React.StrictMode>,
  document.getElementById("root")
);
```

Example showing how a Context Provider is wrapped around a component.

The `createContext` Hook is a feature in React that allows for data flow through the component tree without the need to pass props manually at the component entry level. The Hook includes a React component `<Context.Provider value=/some value/>` that enables any value inserted into the `value` property to be accessed by the child component.

```js
import { createContext } from "react";
// Initialise an empty initial state
const initialState = {};

// Initialise and export the GlobalState which creates a context using the initial state
export const GlobalState = createContext(initialState);

// StoreProvider accepts the wrapped components as props.
export const StoreProvider = ({ children }) => {
  // ...Code logic that changes the context
  const newContext = "";

  // Passing the new context into the Provider value and
  // rendering all children, the value becomes accessible in
  // all child components.
  return (
    <GlobalState.Provider value={newContext}>{children}</GlobalState.Provider>
  );
};
```

Example of using CreateContext Hooks

The ‘useReducer‘ hook in React is similar to the ‘useState‘ hook but is used to apply the Flux pattern. When using ‘useReducer‘, an array with two values is returned. The first value is the reactive ‘state‘, and the second value is a function that ‘dispatches‘ an ‘action‘. The ‘action‘ object, which contains data for the ‘state‘, is used as an argument to trigger the ‘reducer‘ callback function. The ‘reducer‘ function, which is defined by the developer, takes the current ‘state‘ and the ‘action‘ object as arguments. In this implementation, the ‘useReducer‘ function will serve as the Flux pattern ‘dispatcher‘ to the ‘GlobalState‘, with the ‘action‘ object containing data for the ‘state‘.

```js
// The Reducer function accepts the state, and action (in this case the initialState)
const Reducer = (state, action) => {
  // ... perform computations for updating state
  return state;
};
const [state, dispatch] = useReducer(Reducer, initialState);
```

Example of using useReducer Hooks.

By combining the `useReducer` and `createContext` Hooks and passing the `reducer` and `state` functions to the `GlobalState.Provider` value property, child components are able to access the `GlobalState`, which is updated by the `reducer` function and the `dispatch` function to update the `GlobalState`. The `state` structure only accepts JavaScript objects that are defined with a specific format, for example, `Data: color: "red", icon: "warning"`. Once triggered, the `reducer` function de-structures the `data` into its keys and values, copies the current `state` using the spread operator, and either assigns or updates the passed `data` object to the copied `state` using the `data` key.

```js
import React, { createContext, useReducer } from "react";
// Initialise an empty initial state
const initialState = {};
// Initialise and export the GlobalState which creates a context using the initial state
export const GlobalState = createContext(initialState);

// The provider accepts child components (lower level components)
// This provider will wrap around high level components, giving the lover level
// components access to the state.
export const StoreProvider = ({ children }) => {
  // Define the reducer callback function
  const Reducer = (state, action) => {
    // Get the name (key) of the data object.
    const name = Object.keys(action);
    // Get the values from that data object.
    const values = Object.values(action);
    // return the new state, assigning a new object where [name] does not exists.
    // or updating the data object where [name] exists.
    return { ...state, [name]: values[0] };
  };
  const [state, dispatch] = useReducer(Reducer, initialState);
  // Pass the state and dispatch function in the value property.
  return (
    <GlobalState.Provider value={[state, dispatch]}>
      {children}
    </GlobalState.Provider>
  );
};
```

Example on combining useContext and useReducer together to make a global state.

The code implements the Flux pattern in a React app by using a custom global store called `GlobalState` using the createContext and useReducer hooks. The createContext hook allows data flow through the component tree without passing props down at the component entry-level manually. The useReducer hook applies the Flux pattern by serving as the dispatcher to the GlobalState, accepting a reducer function that determines how to compute the next state when triggered by an action dispatched by a component.

The components in the app use the useContext hook to interact with the GlobalState and return an array with two values - the state and dispatch. The GlobalState is initiated in the example code below, and the user's details are retrieved, displayed, and the user's age is assigned or updated in the Stores.

```js
import { useState, useContext } from "react";
import { GlobalState } from "context/store";
export default function DisplayUserInfo() {
  // Defining the GlobalState as Store, and dispatch function as SetStore
  const [Store, setStore] = useContext(GlobalState);
  const [Age, setAge] = useState(0);
  return (
    <div>
      // Example on how to retrieve user details
      <div>{Store.UserDetails.UserName}</div>
      <div>{Store.UserDetails.UserEmail}</div>
      // Input updates the Age state
      <input
        type="number"
        value={Age}
        onChange={(e) => {
          setAge(e.target.value);
        }}
      />
      // Button which on click will update the Global store with the Age state
      <button
        onClick={(e) => {
          setStore({ UserDetails: { Age: 28 } });
        }}
      >
        Add age
      </button>
    </div>
  );
}
```

Example on accessing and updating the global state.

The code architecture ensures that each component is independent and self-contained. While some components may use child components to simplify their code, the top-level component initiates the first dispatch call, and any subscribed component in the entire application will subsequently be updated.
