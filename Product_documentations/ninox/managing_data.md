# Managing Data

## Importing Data

> [!TIP]
> Ninox has detailed documentation about how to import data. **[Link to Ninox documentation](https://docs.ninox.com/en/manage-databases/import-and-export/csv-import)**

1. Navigate to the `Adressen` table.

![Template database](../../images/template_database_11.png)

2. Click the settings wheel button and then click `Import data`.

![Template database](../../images/template_database_12.png)

> [!NOTE]
> The following module is the Importing wizard, follow the steps to import the data.

3. Click `Next` and select the csv file file.

> [!NOTE] > **Note that the data needs to be in a CSV format. And the date formats need to match in the file vs what you do in this step**

![Template database](../../images/template_database_13.png)

4. Assign the columns to the correct fields by dragging the items in the right `Available fields` to the left `Fields to import`.

> [!NOTE]
> Depending on the setup of the database, the column names may be different.

![Template database](../../images/template_database_14.png)

**The `HOT` in the right column is a formula, so you need to use `HOT/`**

![Template database](../../images/template_database_15.png)

**The `Id` in the right column is an auto incremented id for Ninox, so you should ignore it, but Dialogue id, should either be created in the CV before importing or use the existing Dialogue Id from the `Access` database**

![Template database](../../images/template_database_16.png)

5. Click `Next` and preview the changes
6. Make sure the dates are correct

> [!TIP]
> The date formats in Ninox take on your system default formats. Even if you put `yyyy-mm-dd` in the import wizard, it may be `dd-mm-yyyy` here. So make sure to check the date is correct, if so then everything is good.

![Template database](../../images/template_database_17.png)

7. Check if the Time fields are correct.

![Template database](../../images/template_database_18.png)

8. Check for other fields such as `HOT` and other fields like the `qualifiers` `dropdown items` to make sure they are correct.

**`HOT` needs to be either `yes` or `no` in the CSV file**

![Template database](../../images/template_database_19.png)

**Dropdown item fields in the CSV need to be the exact same as the ones in the database, if they aren't you need to change them in the database**

![Template database](../../images/template_database_20.png)

## Creating a new record

To create a new record in the `Addressen` table you need to navigate to activate the editing mode, navigate to the `Adressen` table, click the `+` button, then fill out the required fields.

> [!NOTE]
> Once the new record is created it's important to fill out the required fields such as `Dialogue Id` and `Company name` ect. The `Dialogue Id` should be one number higher than the highest `Dialogue Id` number.

1. Navigate to the `Adressen` table.
 
![Address table](../../images/ninox_code_docs/managing_data_1.png)

2. Click the `+` button to add a new record.

![Address table](../../images/ninox_code_docs/managing_data_2.png)

3. In the popup, fill out the required fields.

> Not all fields need to be filled out, but it's important to fill out the required fields such as `Dialogue Id`, `Company name`, phone numbers and such.

![Address table](../../images/ninox_code_docs/managing_data_3.png)

## Deleting a record

To delete a record simply click on the trash can in the contact view, in some cases you may need administrative privileges.

![Address table](../../images/ninox_code_docs/managing_data_4.png)

