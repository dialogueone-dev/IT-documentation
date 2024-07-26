# Project Status Application User Guide

Welcome to the Project Status Application user guide. This guide will walk you through the steps to install and use the application on both Windows and macOS. Follow the instructions carefully to ensure a smooth experience.

## Table of Contents

1. [Installation](#installation)
   - [Windows](#windows)
   - [macOS](#macos)
2. [Running the Application](#running-the-application)
   - [Windows](#windows-1)
   - [macOS](#macos-1)
3. [Using the Application](#using-the-application)
   - [Transform Data](#transform-data)
   - [Project Mapping](#project-mapping)
4. [Troubleshooting](#troubleshooting)

---

## Installation

### Windows

1. **Download the Application:**

   - Download the application folder from the designated Teams Channel.

2. **Place the Folder:**

   - Once downloaded, place the folder somewhere on your computer where you can easily access it, such as the Desktop or the Documents folder.

3. **Create a Shortcut:**
   - Open the application folder.
   - Right-click on the `.exe` file (e.g., `ProjectStatus.exe`).
   - Select "Create shortcut."
   - Drag the shortcut to your Desktop or any other convenient location.

### macOS

1. **Download the Application:**

   - Download the application folder from the designated Teams Channel.

2. **Place the Folder:**

   - Once downloaded, place the folder somewhere on your Mac where you can easily access it, such as the Desktop or the Applications folder.

3. **Open the Application Folder:**

   - Double-click the application folder to open it.

4. **Create an Alias (Optional):**
   - Right-click on the application file (e.g., `ProjectStatus.app`).
   - Select "Make Alias."
   - Drag the alias to your Desktop or any other convenient location.

## Running the Application

### Windows

1. **Open the Application:**

   - Double-click the shortcut you created or navigate to the `.exe` file in the application folder and double-click it.

2. **Windows Warning Message:**
   - Upon first launch, Windows may display a warning message indicating that the app is from an untrusted developer.
   - Click on "More info."
   - Select "Run anyway."

### macOS

1. **Open the Application:**

   - Double-click the alias you created or navigate to the `.app` file in the application folder and double-click it.

2. **macOS Warning Message:**
   - Upon first launch, macOS may display a warning message indicating that the app is from an unidentified developer.
   - Go to "System Preferences" > "Security & Privacy."
   - In the "General" tab, you will see a message about the blocked application. Click "Open Anyway."

## Using the Application

### Exporting Data from Visma Time

1. **Open the "PS export" book mark:**

   - In Visma Time, navigate to "Indberetninger" and select the tab "Indberetninger".
   - Click on the bookmarks icon at the top center, and under the "Virksomhedsbogmærker" tab, select "PS export".

2. **Select start (and end) date:**

   - Go to "Søgeindstillinger" by clicking on the downward-pointing arrow at the top right corner.
   - Enter the start date (and end date if desired) or select, for example, "Denne måned".
   - Click on "Søg".

3. **Export the data**
   - Export data by clicking on the download icon at the top right corner (downward-pointing arrow with a line underneath).

### Transform Data

1. **Load a File:**

   - Open the application and select the "Transform Data" tab.
   - Drag and drop your Excel or CSV file into the designated area or click to browse and select the file.

2. **Select Output File:**

   - Click on the "Select Output File" button.
   - Choose the location and name for your output file. Ensure to select the appropriate format (CSV or Excel) in the save dialog.

3. **Run the Transformation:**
   - Once the file is loaded and the output file is selected, click on the "Run Script" button.
   - The application will process the file and save the transformed data to the specified output file.
   - A success message will appear once the file is saved successfully.

### Project Mapping

1. **Open the Project Mapping Tab:**

   - Navigate to the "Project Mapping" tab.

2. **Add Project Mapping:**

   - Click on the "Add Row" button to add a new mapping.
   - In the "Client" column, enter the client name as it appears in the input file.
   - In the "Mapped Project" column, enter the corresponding project name as it should appear in the output file.

3. **Save Project Mapping:**
   - The mappings are saved automatically. They will be used during the data transformation process to ensure consistent naming.

## Troubleshooting

- **File Loading Issues:**

  - Ensure the file is in the correct format (CSV or Excel).
  - Check if the file contains the required columns: `Medarbejder`, `Startdato`, `Arbejdskategori`, `Antal`, `Hovedprojekt`, `Projekt`, `Kundenavn`, `Enhed`, `Aktivitet`, `Bemærkninger`.

- **Transformation Errors:**

  - If you encounter an error during transformation, ensure that the data structure is correct and all required fields are present.
  - Check the Project Mapping to ensure all client names are correctly mapped.

- **Application Crashes or Freezes:**
  - Restart the application and try again.
  - Ensure your system meets the minimum requirements to run the application.

For further assistance, please contact the support team.
