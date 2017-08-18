## R Utility - Extract Schema Details from MS SQL Queryplan XML

### Introduction:

MS SQL converts any SQL query into Queryplan before passing it to SQL engine. We can save these Queryplans as XML. 
The Queryplan XML has a tag called "ColumnReference" which contains information about all the columns referred in the query (be it in select or join or where clause) similar to below.

> <ColumnReference Database="[TestDB]" Schema="[dbo]" Table="[Booking]" Alias="[B]" Column="BookedHours"></ColumnReference>
*There will be many such Column Reference tags in the XML*

This utility will read all the Queryplan XMLs placed in the Input folder, extract the schema information and bind it to an output csv file. 

### Objects:

This utility has following objects in folder and a short description about them.


| File Name | Type | Description |
| --- | --- | --- |
| Input | Folder | Place all the MS SQL Queryplan XMLs in this folder. The XML files names will be used as the Table/View name in the output csv file. |
| Output | Folder | The output csv file will be placed in this folder. The output file will be overwritten in every run. |
| fn_extractSchema.R | R | R script that has the function to read the MS SQL Query Plan XML as input, extracts the table schema details and returns the output dataframe |
| fn_LoopReadXML.R | R | R script that has the function to read each XML document present in the Input folder, calls the function fn_extractSchema() to extract the table schema details, bind the output and write it as CSV file to Output folder |
| readme.md | Markdown | Documentation |
| script_execFunctions.R | R | R script to call fn_LoopReadXML R function |
| run.bat | Batch | Windows batch script that executes the R script \"script_execFunctions.R\" |

### How to run this utility:

Following are the steps to run this utility,

* Ensure that latest R version is installed in your machine. If not download and install it from <https://cran.r-project.org/> 

* Install the “xml2” & "stringi" R packages

* Edit the “Run.bat” file

* Update the R Script location to the R bin folder in server/local machine

* Save “Run.bat” file

* click on “Run.bat” file to run this utility

### Note:

This utility will serve as an example for following tasks,

* Write a R function

* How to import data from XML file to R dataframe

* How to find all tags with specific name in XML document and read the attributes as Key-Value pairs

* How to melt a list of dataframe with varying number of columns into a single dataframe

* How to loop through the R dataframe

* How to write the output to a CSV file

* How to call R script from windows command line using a batch file


