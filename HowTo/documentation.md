# Creating a Docsify Site

> The documentation can be found here [dialogueone-dev/IT-documentation](https://github.com/dialogueone-dev/IT-documentation)

> The documentation for using Docsiy can be found here [docsifyjs/docsify](https://docsify.js.org/#/)

## Setup

1. Go to the [dialogueone-dev/IT-documentation](https://github.com/dialogueone-dev/IT-documentation) repository on GitHub.
2. Click the green "Code" button and select "Download ZIP" to download the repository code to your computer.
3. Extract the contents of the ZIP file to a new directory on your computer. For example, you could create a new directory called `my-docsify-site` and extract the ZIP file contents to that directory.
4. Open your terminal or command prompt and change into the directory where you extracted the ZIP file. For example, if you created a directory called `my-docsify-site` and extracted the ZIP file to that directory, you would run the following command: `cd my-docsify-site`.
5. Install Docsify globally by running the following command: `npm install -g docsify-cli`.
6. Initialize your Docsify site by running the following command: `docsify init ./`.
7. Start the Docsify development server by running the following command: `docsify serve`.

### Accessing Your Organization's GitHub Account

To access Dialogue One A/s organization's GitHub account, please contact the IT administrator.

## Writing in Markdown

Docsify supports writing documentation in Markdown format, which is a lightweight markup language that is easy to read and write.

Here are some basic Markdown syntax examples:

- Headings: Use `#` to indicate headings. For example, `# Heading 1` creates a first-level heading, and `## Heading 2` creates a second-level heading.
- Lists: Use `*` or `-` to create bullet points, and use numbers to create numbered lists.
- Links: To create a link, use the following format: `[Link text](URL)`. For example, `[Docsify website](https://docsify.js.org)` creates a link to the Docsify website.
- Images: To insert an image, use the following format: `![Alt text](image URL)`. For example, `![Docsify logo](https://docsify.js.org/_media/icon.svg)` inserts the Docsify logo image.

For more information on Markdown syntax, see the [Markdown Guide](https://www.markdownguide.org/basic-syntax/).

## Adding Links

To add links to your Docsify site, create a new Markdown file for each page you want to link to, and add a link to that file in your navigation menu.

1. Create a new Markdown file in your Docsify site directory. For example, to create a page called "About Us", run the following command: `touch about.md`.
2. Edit the Markdown file and add your content.
3. Add a link to your new page in your navigation menu. To do this, edit the `_sidebar.md` file in your Docsify site directory and add a new entry to the list. For example, to add a link to your "About Us" page, add the following line: `- [About Us](about.md)`.

## Building and Publishing Your Docsify Site with GitHub Actions

The `dialogueone-dev/IT-documentation` repository already has a GitHub Action set up to build and publish the Docsify site whenever you push changes to the repository. This means that you don't need to set up the action yourself; it's already configured and ready to go.

When you push changes to the `main` branch of your repository, the GitHub Action will automatically trigger and build your Docsify site based on the changes you made to the Markdown files in the `docs` directory. The output of the build process will be published to the `gh-pages` branch of your repository, which can be accessed at [https://dialogueone-dev.github.io/IT-documentation/#/](https://dialogueone-dev.github.io/IT-documentation/#/).

To update your Docsify site, simply edit the Markdown files in the `docs` directory, commit the changes to your repository, and push the changes to GitHub. The GitHub Action will automatically build your site and publish it, making it available to your users.
