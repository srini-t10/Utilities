
#*******************************************************************************************************
# Function Name: fn_LoopReadXML() 
#
# Arguments: 
# None
#
# Description: 
# This function reads each XML document present in the Input folder, calls the function fn_extractSchema() 
# to extract the table schema details from it, bind the output and write it as CSV file to Output folder
#
# Author: srini-t10
#
# Version: 0.1
#
#*******************************************************************************************************

# Begin fn_LoopReadXML() funtion ... 

fn_LoopReadXML <- function()
{
  # Load Required packages
  require(xml2)
 
  #set input, output locations
  xmllocation <- "./Input/"
  outlocation <- "./Output/"
  
  # Read all the xml file names
  filename <- list.files(xmllocation)
  
  # Initiate Output variable
  output <- NULL
  
  # Extract schema from each xml
  for(i in 1:length(filename)) {
    xmldoc <- read_xml(paste(xmllocation,filename[i],sep = ""))
    readschema <- fn_extractSchema(xmldoc)
    readschema <-cbind(FileName= sub(".xml","",filename[i]), readschema)
    output <- rbind(output,readschema)
  }
  
  names(output) <- c("TableName","SourceDatabase","SourceSchema","SourceTable","SourceTableAlias","SourceColumn")
  
  write.csv(output,paste(outlocation,"Schema.csv",sep = ""), row.names = F)
  
  message("Execution Successful! schema.csv file is placed in Output folder..")
  
}

# End fn_LoopReadXML() funtion 


#*******************************************************************************************************

# Test:
# --------------------------------------------------------

# > source("fn_extractSchema.R")
# > source("fn_LoopReadXML.R")
# > fn_LoopReadXML("./poc","./output")
