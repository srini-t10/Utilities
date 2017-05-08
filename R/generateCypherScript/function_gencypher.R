#*******************************************************************************************************
# Function Name: gencypher() 
#
# Arguments: 
# This function takes  argument from the config.json file. 
#
# Description: 
# This function reads the aruments given for each node and relationship in config.json file
# and create the corresponding CYPHER script.
# The CYPHER script will be stored in a text file under "Output" folder.
#
# Author: v-srt
#
# Version: 0.1
#
#*******************************************************************************************************

# Begin gencypher() funtion ... 

gencypher <- function() {
      
      # Load the required libraries
      require("tools")
      
      if(!require("jsonlite")){
            return(
                  stop("This function requires jsonlite package!",
                       "Please Install the jsonlite package.")
            )
      }

      # Read the configuration file
      config <- fromJSON("config.json")
      
      # Create Output Directory if it doesnt exists
	if(!dir.exists("Output")) {
		dir.create("Output")
	}
      
      
      # Subfunction to create the Cypher script for Nodes
      nodecypherscript <- function(filenum, csvfilename, nodename, uniquekey, attribute ) {
            
            property <- NULL 
            
            for (i in 1:length(attribute)) {
                  if(length(attribute) >= 1) {
                        property <- c(property,
                                      paste(if(i>1){", "}else{" "},"node."
                                            ,attribute[i]," = InputData.",attribute[i],sep=""))
                  }
            }
            
            
            # create the basic merge query
            cat("\n",
                "// ",filenum,". Load Node - ",nodename,":","\n",
                "LOAD CSV WITH HEADERS","\n",
                "FROM \"file:///",csvfilename,"\"","\n",
                "AS InputData","\n",
                "MERGE (node:",nodename," {",uniquekey,":InputData.",uniquekey,"})","\n",
                sep = ""
            )
            
            # if any attributes present then add "On create"/"on match" statement
            if(length(attribute) >= 1){
                  
                  # On Create
                  cat("ON CREATE SET","\n",property,"\n",sep = "")
                  cat("ON MATCH SET","\n",property,"\n",sep = "")

            }
            
            # create the unique constraint query   
             cat("\n",
                 "CREATE CONSTRAINT ON (node:",nodename,") ASSERT node.",uniquekey," IS UNIQUE",
                "\n\n", sep = ""
            )
      }
      
      
      
      # Subfunction to create the Cypher script for Relationship
      relationcypherscript <- function(filenum, csvfilename, node1name, node1key, 
                                       node2name, node2key, RelationshipName ) {
            
            
            # create the relationship merge query
            cat("\n",
                "// ",filenum,". Load Relationship between ",node1name,"and ",node2name,":","\n",
                "USING PERIODIC COMMIT 5000","\n",
                "LOAD CSV WITH HEADERS","\n",
                "FROM \"file:///",csvfilename,"\"","\n",
                "AS InputData","\n",
                "MATCH","\n",
                " (node1:",node1name,"{",node1key,":InputData.",node1key,"})","\n",
                ",(node2:",node2name,"{",node2key,":InputData.",node2key,"})","\n",
                "MERGE (node1)-[:",RelationshipName,"]->(node2)","\n",
                sep = ""
            )
            
      }
      
      # Initialize vector to store node script & relationship script output
      outputnodescript <- paste("// Ensure that the input csv files are present under \"import\"",
                            "folder in Neo4j Databse location.")
      
      outputrelationscript <- paste("// Ensure that the input csv files are present under \"import\"",
                                "folder in Neo4j Databse location.")
      
      nodefilenum <- 0
      relationfilenum <- 0
      
      
      # Generate script for each row in configuration file
      for(i in 1:nrow(config)) {
            
            if(config[i,"Type"] == "Node") {
                  nodefilenum <- nodefilenum + 1
                  
                  # Get the non NA attribute/column/property names
                  isattributeNA <- is.na(config[i,])  
                  attribute <- as.character(subset(config[i,!isattributeNA],
                                                   select = -c(FileName,Type,NodeName,UniqueKeyColumn)))
                  
                  # Generate the cypher script for current row in loop
                  loopvalue <- capture.output(nodecypherscript(nodefilenum,
                                                               config[i,"FileName"],
                                                               config[i,"NodeName"],
                                                               config[i,"UniqueKeyColumn"],
                                                               attribute
                                                               )
                                              )
                  
                  # Append the cypher script to all previously generated scripts
                  outputnodescript<-c(outputnodescript,loopvalue)
                              
            }
            
            if(config[i,"Type"] == "Relationship") {
                  relationfilenum <- relationfilenum + 1
                  
                  # Generate the cypher script for current row in loop
                  loopvalue <- capture.output(relationcypherscript(relationfilenum,
                                                               config[i,"FileName"],
                                                               config[i,"Node1Name"],
                                                               config[i,"Node1Key"],
                                                               config[i,"Node2Name"],
                                                               config[i,"Node2Key"],
                                                               config[i,"RelationshipName"]
                                                               )
                                              )
                  
                  # Append the cypher script to all previously generated scripts
                  outputrelationscript<-c(outputrelationscript,loopvalue)
                  
            }
            
      }
      
      write(outputnodescript,"Output\\cypherscript_Node.txt")
      message("Create Cypher Script file for Nodes ... Completed!")
      write(outputrelationscript,"Output\\cypherscript_Relationship.txt")
      message("Create Cypher Script file for Relationships ... Completed!")
      
}

# End gencypher() funtion 

#****************************************************************************************************

