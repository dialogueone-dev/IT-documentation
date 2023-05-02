> # REST API

This part of the documentation is meant to provide a detailed understanding of the REST API used in the backend of the Project Status plugin. The REST API is used to communicate with the Dialogue Time API to receive the data needed to calculate the project status.

> Mainly, this section will talk about the `retrieve_project_status.js` file in routes

## Project status route

This route is used to retrieve the project status of a project. It is a `POST` request that takes in the following request body:

- `dateStart`: The start date
- `dateEnd`: The end date

The `authHelper.validateJwt` middleware function is used to check the validity of the JSON Web Token (JWT) sent in the request header. If the JWT is valid, the middleware function will add the decoded JWT to the request object.

The `oboRequest` object is created, containing the OAuth 2.0 On-Behalf-Of (OBO) flow assertion and the necessary scopes for accessing the API. The `oboAssertion` property of the `oboRequest` object is assigned the value of the access token sent in the authorization header of the request.

The `scopes` property of the `oboRequest` object is set to an array of scopes required for accessing the API.

```js
router.post(
    "/project_status",
    authHelper.validateJwt,
    async function (req, res) {
        try {
            const authHeader = req.headers.authorization;
            let oboRequest = {
                oboAssertion: authHeader.split(' ')[1],
                scopes: ["files.read",
                    "Directory.AccessAsUser.All",
                    "Directory.Read.All",
                    "Directory.ReadWrite.All",
                    "Group.Read.All",
                    "GroupMember.Read.All",
                    'openid',
                    'profile',
                    "User.Read",
                    "User.Read.All",
                    "User.ReadBasic.All",
                    "User.ReadWrite",
                    "User.ReadWrite.All",
                ],
            };
    // .... more code
        }
    // .... more code
})
```

### Using JVT to check the validity of the token

The `jwt.decode` function is used to decode the OBO assertion and extract the `scp` (scope) claim. The `split` method is used to split the `scp` claim into an array of individual scopes. The `find` method is used to find the `access_as_user` scope in the array of scopes.
If the `access_as_user` scope is not found, a `401 response` with an error message is returned.

```js
// .... more code
const tokenScopes = jwt.decode(oboRequest.oboAssertion).scp.split(" ");
const accessAsUserScope = tokenScopes.find(
  (scope) => scope === "access_as_user"
);
if (!accessAsUserScope) {
  res.status(401).send({ type: "Missing access_as_user" });
  return;
}
// .... more code
```

### Defining the tokens and logging in

Then the `authHelper.getConfidentialClientApplication` function returns a new instance of the `ConfidentialClientApplication` class, which is used to acquire access tokens for the API. The `cca.acquireTokenOnBehalfOf` method is used to exchange the OBO assertion for an access token to use for making API requests.

The login function is called with the access token as a parameter to log into Dialogue Time's API and retrieve a Bearer token and

```js
// .... more code
const cca = authHelper.getConfidentialClientApplication();
const response = await cca.acquireTokenOnBehalfOf(oboRequest);
const login_to_dialogue = await login(response.accessToken);
// .... more code
```

### Retrieving the project status

Now that we have access to the JWT access token to Dialogue Time API we can use it to retrieve the project status. Firstly we define the parameters to use before calling the Dialogue Time API.

```js
// .... more code
const accessToken = login_to_dialogue.accessToken;
const Bearer = login_to_dialogue.Bearer;
const dateStart = req.body.dateStart;
const dateEnd = req.body.dateEnd;
const teams = [
  "f0b7f18d-ce6d-4067-9d71-3cec1884c061",
  "2ad98789-62fd-44a8-a19b-c8c3ee26b499",
  "c31bc115-8b03-4b09-a840-27199bb8f630",
];
const param = {
  teams: teams,
  start: dateStart,
  end: dateEnd,
  bearer: Bearer,
};
// .... more code
```

### Calling the Dialogue Time API

This section of the code retrieves the project status by sending a POST request to the `https://api-v2.dialogueone.com/api/Hours/Departments` API endpoint of Dialogue Time's API. The `Bearer token` is included in the header of the request to authenticate the user. The param variable contains the necessary parameters for the request, including the start and end dates and the team IDs. Once the request is sent, the response is parsed into a JSON object and returned.

```js
// .... more code wrapped in Try catch
const project_url = `${baseURL}/Hours/Departments`;
const project_data = await fetch(project_url, {
  method: "POST",
  headers: {
    "Content-Type": "application/json",
    MSBearerToken: Bearer,
    msbearertoken: Bearer,
    "x-access-token": accessToken,
    useruuid: login_to_dialogue.id,
  },
  body: JSON.stringify(param),
});
const project_status = await project_data.json();
```

### Retrieving the schedule

This section of the code retrieves the schedule for the specified teams and dates by sending a GET request to the `https://api-v2.dialogueone.com/api/Schedule/teams/:teamids/month/:month` API endpoint of Dialogue Time's API. The `Bearer` token is included in the header of the request to authenticate the user. The `param2` variable contains the necessary parameters for the request, including the start and end dates and the team IDs. Once the request is sent, the response is parsed into a JSON object and returned. The `for` loop iterates over the `ScheduleReportArray` and deletes the `Team_id` property for each object before assigning it to the `project_status.schedule` property.

```js
// .... more code
const param2 = {
  month: [param.start, param.end],
  teamids: teams,
};
const schedule_url = `${baseURL}/Schedule/teams/${JSON.stringify(
  param2.teamids
)}/month/${JSON.stringify(param2.month)}?bearer=${Bearer}`;

const schedule_data = await fetch(schedule_url, {
  method: "GET",
  headers: {
    "Content-Type": "application/json",
    MSBearerToken: Bearer,
    msbearertoken: Bearer,
    "x-access-token": accessToken,
    useruuid: login_to_dialogue.id,
  },
});
const schedule_status = await schedule_data.json();
for (const s of schedule_status.ScheduleReportArray) {
  delete s.Team_id;
}
project_status.schedule = schedule_status.ScheduleReportArray;
```

### Returning the response

Finally, the response is returned to the client.

```js
return res.status(200).send(project_status);
```

## Dialogue Time's login route

The `login` function is used to log into Dialogue Time's API and retrieve a Bearer token and an access token. The `token` parameter is the access token retrieved from the OBO assertion.

```js
const baseURL = "https://api-v2.dialogueone.com/api";
async function login(token) {
  const body = {
    token: token,
  };
  try {
    const data = await fetch("https://api-v2.dialogueone.com/api/auth/signin", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(body),
    });
    return await data.json();
  } catch (error) {
    console.log(error);
  }
}
```
