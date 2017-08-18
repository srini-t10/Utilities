#*******************************************************************************************************
# Function Name: fn_extractSchema() 
#
# Arguments: 
# The function takes one argument "xmldoc", which is a MS SQL Query Plan XML. 
# 
#
# Description: 
# This function takes the MS SQL Query Plan XML as input and extracts the table schema details
# and gives it as a output. 
#
# Author: srini-t10
#
# Version: 0.1
#
#*******************************************************************************************************

# Begin fn_extractSchema() funtion ... 

fn_extractSchema <- function(xmldoc)
{
  # Load Required packages
  require(xml2)
  require(stringi)
  
  # Get all ColumnReference element from the xml document
  colref <- xml_find_all(xmldoc,"//d1:ColumnReference",xml_ns(xmldoc))
  
  # Get all the attributes from ColumnReference elements, output will be a list of data frames.
  colref_attr <- xml_attrs(colref)
  
  
  # Convert the list into matrix, transpose and store it as data frame
  colref_attr_df <- na.omit(data.frame(unique(stri_list2matrix(colref_attr,byrow = T))))
  
  
  #Return the cleansed output
  colref_attr_df
  
}

# End fn_extractSchema() funtion 
