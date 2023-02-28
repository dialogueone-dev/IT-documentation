> # Getting started

## Development server

You'll need to have Yarn installed <https://yarnpkg.com/> to install the dependencies.

`yarn`

The yarn package manager should install all the dependencies.
then run

`yarn start`

## Starting point

The application starting point is `src/app/index.js`, much like a normal react app starting point. However here we also import our custom `store` and our `theme` (more on these later).

```js
import Authenticate from "./App/authenticate";
import { StoreProvider } from "./context/store.js";
import "assets/css/material-dashboard-react.css?v=1.10.0";
import "./index.css";
import { MaterialUIControllerProvider } from "context";
import "App/Views/Users/Schedule/schedule.css";
import "context";
import { createRoot } from "react-dom/client";
const container = document.getElementById("root");
const root = createRoot(container);
root.render(
  <MaterialUIControllerProvider>
    <StoreProvider>
      <Authenticate></Authenticate>
    </StoreProvider>
  </MaterialUIControllerProvider>
);
```
