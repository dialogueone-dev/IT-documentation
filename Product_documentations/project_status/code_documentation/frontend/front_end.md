> # Front End

The front-end of Project Status is an Excel plugin that utilizes the Office.js library to interact with the Excel document. The plugin is built using HTML, CSS, and JavaScript and is developed using Node.js.

### Office.js API Library

The Office.js library provides a set of JavaScript APIs that enable developers to interact with the Excel document and other Office applications. The library includes functions for manipulating cell data, formatting, and styling, as well as functions for working with tables, charts, and other Excel objects.

> Find more comprehensive documentation for the Office.js library [here](https://docs.microsoft.com/en-us/office/dev/add-ins/reference/overview/excel-add-ins-reference-overview).

### HTML and CSS

The front-end of Project Status is designed using HTML and CSS. The HTML markup defines the structure of the plugin, while the CSS styles are used to format and style the plugin elements.

The HTML and CSS code for the plugin can be found in the `public` directory of the Node.js application.

### JavaScript

The front-end of Project Status is implemented using JavaScript. The JavaScript code is responsible for interacting with the Office.js library and updating the Excel document based on user input.

The JavaScript code for the plugin can be found in the `public` directory of the Node.js application. The `app.js` file contains the main JavaScript code for the plugin, while other JavaScript files may be used for specific functionality.

### Pug

The rendering of the Project Status plugin is handled by a Pug file located in the `views` directory. The `index.pug` file defines the structure of the task pane page and includes references to the necessary JavaScript and CSS files.

```pug
extends layout

block content
  div#connectContainer

    div#iconContainer
      img(src="/assets/images/icon.png" alt="Logo")

    div#avatar.collection
      li.collection-item.avatar
        img#photo(src="" alt="profile" class="circle")
        p#username
        p#email
      li.collection-item#message-area

      div#message-load.display_none.preloader-wrapper.medium.active
        div.spinner-layer.spinner-blue-only
          div.circle-clipper.left
            div.circle
          div.gap-patch
            div.circle
          div.circle-clipper.right
            div.circle

    div.container
      div.col(style="text-align:center;")
        div.col
          label(for="startDatePicker") Start Date:
          input#startDatePicker.datepicker(type="text" name="startDate")
        div.col
          label(for="endDatePicker") End Date:
          input#endDatePicker.datepicker(type="text" name="endDate")

        a#getFileNameListButton.waves-effect.waves-light.btn(style="margin-top: 2rem") Retrieve project status
```

### Single Sign-On (SSO)

Project Status also includes Single Sign-On (SSO) functionality, which allows users to sign in to the plugin using their Office 365 credentials. The SSO functionality is implemented using the `@microsoft/office-addin-sso` library, which provides a set of functions for handling authentication and access tokens.

The SSO code for Project Status is implemented using Node.js and can be found in the `auth` directory of the Node.js application. The code is based on the `Office-Add-in-NodeJS-SSO` sample from the Office-Add-in-samples repository on GitHub.

## Conclusion

In conclusion, the front-end of Project Status is implemented using HTML, CSS, and JavaScript and utilizes the Office.js library for interacting with the Excel document. The SSO functionality is implemented using the `@microsoft/office-addin-sso` library and is based on the Office-Add-in-NodeJS-SSO sample from the Office-Add-in-samples repository on GitHub. If you encounter any issues with the front-end of Project Status, consult the official Office.js documentation or contact our support team for assistance.
