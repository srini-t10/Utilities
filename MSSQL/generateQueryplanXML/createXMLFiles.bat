sqlcmd -S ESVMUnityDev1 -d dbRKS -i SQLFiles\report.vwAttribute.sql -y0 -o QueryplanXML\report.vwAttribute.xml
sqlcmd -S ESVMUnityDev1 -d dbRKS -i SQLFiles\report.vwAttributeMap.sql -y0 -o QueryplanXML\report.vwAttributeMap.xml
sqlcmd -S ESVMUnityDev1 -d dbRKS -i SQLFiles\report.vwReport.sql -y0 -o QueryplanXML\report.vwReport.xml