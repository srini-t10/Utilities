
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
# Version: 0.2
#
#*******************************************************************************************************

# Begin fn_LoopReadXML() funtion ... 

fn_LoopReadXML <- function()
{
  # Load Required packages
  require(xml2)
  require(stringi)
 
  #set input, output locations
  xmllocation <- "./Input/"
  outlocation <- "./Output/"
  
  # Read all the xml file names
  filename <- list.files(xmllocation)
  
  # Initiate Output variable
  output <- NULL
  ErrorCount <- 0
  
  
  
  # Extract schema from each xml
  
  message("")
  message("Processing XML Files from Input Folder..")
  
  for(i in 1:length(filename)) {
    
        # Display message
        message(i,"/",length(filename)," ",filename[i])
        
        # extract schema information from XML, execute in a try block
        tryERROR <- try(
            {
            xmldoc <- read_xml(paste(xmllocation,filename[i],sep = ""))
            readschema <- fn_extractSchema(xmldoc)
            readschema <-cbind(FileName= sub(".xml","",filename[i]), readschema)
            }
        )
        
        # Insert Error row if error occured
        if(class(tryERROR) == "try-error")
        {
            ErrorCount <- ErrorCount + 1
            readschema <-c(sub(".xml","",filename[i]), 
                           c("ERROR",
                             "ERROR",
                             "ERROR", 
                             geterrmessage()))
            readschema <-rbind(readschema)  
        }
        # if no error, bind the results
        else if(length(colnames(readschema)) == 6)
        {
            readschema <-readschema[,c(1:4,6)]
        }
        else if(length(colnames(readschema)) == 5)
        {
            readschema <-readschema
        }
        else
        {
            readschema <-c(sub(".xml","",filename[i]), 
                           c("Schema Not Found",
                             "Schema Not Found",
                             "Schema Not Found", 
                             "Schema Not Found"))
            readschema <-rbind(readschema)  
        }
        
        
        colnames(readschema) <-c("TableName","SourceDatabase","SourceSchema","SourceTable","SourceColumn")
        
        # bind the result for each file in an output dataframe
        output <- rbind(output,readschema)
        
      
  }
  
  write.csv(output,paste(outlocation,"Schema.csv",sep = ""), row.names = F)
  
  message("")
  message("Execution Successful! schema.csv file is placed in Output folder..")
  message("Total File Procesed: ",length(filename),", Succesfully Processed: ",length(filename)-ErrorCount,", Not Processed due to XML File Error: ",ErrorCount,"..")
  
}

# End fn_LoopReadXML() funtion 


#*******************************************************************************************************

# Test:
# --------------------------------------------------------

# > source("fn_extractSchema.R")
# > source("fn_LoopReadXML.R")
# > fn_LoopReadXML("./poc","./output")
