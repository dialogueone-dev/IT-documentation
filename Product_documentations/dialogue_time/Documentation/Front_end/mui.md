> # Material UI

Material UI is a React UI framework that provides a set of reusable React components that implement Google's Material Design. It is used in the Dialogue Time application to create a consistent and responsive user interface.

## Templates and Components

Dialogue Time uses a template pack from Creative Tim called [Material Dashboard React](https://www.creative-tim.com/product/material-dashboard-react). This template pack provides a set of pre-built React components that implement Material Design. The components are organized into the following categories:

- **Admin Layout** - Components for the admin dashboard layout, including the sidebar, navbar, and footer.
- **Cards** - Components for displaying information in cards, such as statistics, notifications, and user profiles.
- **Charts** - Components for displaying charts and graphs.
- **Forms** - Components for creating forms and form fields.
- **Notifications** - Components for displaying notifications.
- **Plugins** - Components for integrating with external plugins.
- **Sidebar** - Components for the sidebar.
- **Table** - Components for displaying tables.
- **Typography** - Components for displaying text.

## Theming

The template pack comes with a default theme and a dark theme that can be customized in files existing inside `arc/app/assets/theme/` or `arc/app/assets/theme-dark/` directories. The themes extend the default Material UI theme and override the default values for many of the theme variables. The theme variables are used throughout the application to define the colors, fonts, and other styles of the user interface.

### Base variables

Colors, fonts, borders and other styles are defined in the base variables file `arc/app/assets/theme{-dark}/base/` directory. The base variables are used to define the default theme and the dark theme.

### Components

The components directory contains files that define the styles for the Material UI components. The styles are defined using the base variables and the Material UI theme variables. The components directory contain many of the components used in the Dialogue Time application.
