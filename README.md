## Index

#### 1. [R/generateCypherScript](R/generateCypherScript/)

*Generate Cypher Script* is an utility created with R Script. It reads the list of nodes, relationships and input CSV file name from a JSON configuration file and outputs the Cypher script. The generated cypher script can be used to create the nodes and relationship on Neo4j database.

#### 2. [R/extractFromQueryplanXML](R/extractFromQueryplanXML/)

This R utility will read all the MSSQL Queryplan XMLs placed in the Input folder, extract the schema information and bind it to an output csv file. 

#### 3. [MSSQL/generateQueryplanXML](MSSQL/generateQueryplanXML/)

MS SQL converts any SQL query into Queryplan before passing it to SQL engine. We can save these Queryplans as XML and extract the Tables/Columns used in the query. This utility describes and applied a method to generate Queryplan XMLs for the given list of SQL queries and save it in a folder.
