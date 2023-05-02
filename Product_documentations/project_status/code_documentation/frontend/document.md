> # Writing to Document

One of the main functions `writeJsonToWorksheet` is responsible for writing the data to the Excel worksheet, it's found in `public/javascripts/document.js`. The function begins with an `Excel.run` call. This method ensures that the code is executed within an Excel context and allows you to interact with Excel through the `context` object.

```js
async function writeJsonToWorksheet(jsonArray) {
  return Excel.run(async function (context) {
    // code here
  });
}
```

The `calculationMode` of the Excel application is set to `Manual` to prevent the sheet from constantly recalculating as data is being written to it. This can greatly improve performance when dealing with large amounts of data.

```js
context.application.calculationMode = "Manual";
```

The code attempts to retrieve the "Report" worksheet object, and if it does not exist, it creates a new worksheet with that name.

```js
var sheet = context.workbook.worksheets.getItemOrNullObject("Report");
if (sheet.isNullObject) {
  sheet = context.workbook.worksheets.add("Report");
}
```

The range of all used cells on the worksheet is cleared to remove any existing data.

```js
var usedRange = sheet.getUsedRange();
usedRange.clear();
```

The header row for the data is written to the worksheet.

```js
var headerRange = sheet.getRange("A1:L1");
headerRange.values = [
  [
    "Name",
    "Caller",
    "Team",
    "Datum",
    "Stunden",
    "Projekt",
    "Task",
    "Bemerkung",
    "Kontakte",
    "Meetings",
    "Supplement",
    "Transaction_ID",
  ],
];
```

The data rows are written to the worksheet. A new array is created (`allrows`) to store the data and then iterates over the `jsonArray` passed as a parameter to the function. The keys of the `jsonObject` are modified and pushed to the values array to be written to the worksheet. Finally, the `allrows` array is written to the worksheet.

```js
var rowNumber = 2;
let allrows = [];
for (var i = 0; i < jsonArray.Hour.length; i++) {
  var values = [];
  var jsonObject = jsonArray.Hour[i];

  // Modify the keys here
  jsonObject.Projekt = jsonObject.Project;
  jsonObject.Bemerkung = jsonObject.Description;
  jsonObject.Kontakte = jsonObject.Contacts;

  // Modify the order of the keys here
  values.push(jsonObject.Name);
  values.push(jsonObject.Caller);
  values.push(jsonObject.Team);
  values.push(jsonObject.Datum);
  values.push(jsonObject.Stunden);
  values.push(jsonObject.Projekt);
  values.push(jsonObject.Task);
  values.push(jsonObject.Bemerkung);
  values.push(parseFloat(jsonObject.Kontakte));
  values.push(parseFloat(jsonObject.Meetings));
  values.push(jsonObject.Supplement);
  values.push(jsonObject.Transaction_ID);

  rowNumber++;
  allrows.push(values);
}

var rowRange = sheet.getRange("A2:L" + (rowNumber - 1));
rowRange.values = allrows;
```

The "Schedule" worksheet is handled in a similar way as the "Report" worksheet. The worksheet is retrieved or created, and then the data is written to it.

```js
var schedule_sheet =
  context.workbook.worksheets.getItemOrNullObject("Schedule");
if (schedule_sheet.isNullObject) {
  schedule_sheet = context.workbook.worksheets.add("Schedule");
}

var usedRange_schedule = schedule_sheet.getUsedRange();
usedRange_schedule.clear();

var headerRange_schedule = schedule_sheet.getRange("A1:D1");
headerRange_schedule.values = [["Name", "Caller", "Hours", "Team"]];
```

After clearing the used range and writing the column headers, the function loops through the `jsonArray` and extracts the necessary data, modifies it if needed, and pushes it into the `allrows` array. It also increments the `rowNumber` counter, which is used to set the range where the values will be written.

```js
for (var i = 0; i < jsonArray.Hour.length; i++) {
  var values = [];
  var jsonObject = jsonArray.Hour[i];

  // Modify the keys here
  jsonObject.Projekt = jsonObject.Project;
  jsonObject.Bemerkung = jsonObject.Description;
  jsonObject.Kontakte = jsonObject.Contacts;

  // Modify the order of the keys here
  values.push(jsonObject.Name);
  values.push(jsonObject.Caller);
  values.push(jsonObject.Team);
  values.push(jsonObject.Datum);
  values.push(jsonObject.Stunden);
  values.push(jsonObject.Projekt);
  values.push(jsonObject.Task);
  values.push(jsonObject.Bemerkung);
  values.push(parseFloat(jsonObject.Kontakte));
  values.push(parseFloat(jsonObject.Meetings));
  values.push(jsonObject.Supplement);
  values.push(jsonObject.Transaction_ID);

  rowNumber++;
  allrows.push(values);
}
```

Once all the data is collected, the function sets the range of the rows and writes the data using the `values` property. Finally, it autofits the columns, recalculates all the formulas in the workbook, and sets the calculation mode back to "automatic."

```js
var rowRange = sheet.getRange("A2:L" + (rowNumber - 1));
rowRange.values = allrows;
await context.sync();
//  ====== Schedule

// ...

// Autofit the columns
showMessage("Calculating...");
// Recalculate all formulas in each sheet
var sheets = context.workbook.worksheets;
for (var i = 0; i < sheets.count; i++) {
  var sheet = sheets.getItemAt(i);
  sheet.calculate();
}
await context.sync();

context.application.calculationMode = "automatic";
```

This function writes the KPIs and schedule to an Excel worksheet in the Office document. It is called by the `writeFileNamesToOfficeDocument` function, which routes the call to this function if the Office host application is Excel. If the host application is Word or PowerPoint, a different function is called instead.
