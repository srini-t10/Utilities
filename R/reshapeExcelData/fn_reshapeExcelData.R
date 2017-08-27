#*******************************************************************************************************
# Function Name: fn_reshapeExcelData() 
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

# Begin fn_reshapeExcelData() funtion ... 

fn_reshapeExcelData <- function()
{
  # set input, output locations
  inlocation <- "./Input/"
  outlocation <- "./Output/"
  
  # check if required packages present else install and load
  if(!require(tidyr)){
      message("Installing the required package: tidyr ","\n")
      install.packages("tidyr")
      library(tidyr)
  }
  
  if(!require(readxl)){
    message("Installing the required package: readxl ","\n")
    install.packages("readxl")
    library(readxl)
  }
  
  if(!require(XML)){
    message("Installing the required package: xml ","\n")
    install.packages("XML")
    library(XML)
  }
  
  
  # Run the code in try block, for error handling
  tryERROR <- try (
    {
      
      # read config file
      config <- xmlToDataFrame("config.xml", stringsAsFactors = F)
      
      # read data from input excel
      filename <- paste(inlocation,config[1,"FILENAME"],sep = "")
      inputdata <- read_excel(filename)
      action <- config[1,"ACTION"]
      
      # Input action is "unite" i.e. convert long format to comma seperated values
      if (action == "unite")
      {
        # spreadData <- spread(longData,key= "ActorNumber", value = "Actor")
        # uniteData <- unite(spreadData, col = "Actors", -c(Movie,YearReleased), sep = ",")
      }
      
      # Input action is "spread" i.e. convert comma seperated values to long format
      else if (action == "spread")
      {
        # Identify the max number of coluls to create, based on max delimit value
        columntosplit <- config[1,"COLUMNTOSPLIT"]
        delimiter <- config[1,"DELIMITER"]
        datatosplit <- sapply(inputdata[,columntosplit],as.character)
        maxcol <- max(sapply(strsplit(datatosplit,delimiter),length))
        splitcolumnNames <- paste(columntosplit,1:maxcol,sep = "")
        
        # Seperate the given column into multiple columns
        sepVal <- separate(inputdata,col = columntosplit, into = splitcolumnNames)
        
        # Convert into long format
        longdata <- gather(sepVal, key="Key", value = "Value",splitcolumnNames[])
        
        # write the output
        write.csv(longdata, paste(outlocation,"TransposedData.csv",sep = ""), row.names = F)
        message("Data is transposed successfully! The file is placed in Output folder.. ")
        
      }
      
      # Invalid input action given, return message
      else
      {
        message("Enter a valid action as input. i.e either \"spread\" (or) \"unite\" in the config.xml file")
      }
    }
      
  )
  
  if(class(tryERROR) == "try-error")
  {
    geterrmessage()
  }
  
}

# End fn_reshapeExcelData() funtion ... 
  