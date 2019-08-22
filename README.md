# Sample-Data
Example MS MS XML data from Waters TQD

Problem: trouble parsing in heavily nested XML data from liquid chromatography analysis software (Waters TargetLynx)

Solution: trying to create R script that is flexible enough to be applied to XML files of slightly different size, to parse and tidy XML data into R data frame for further analysis. Using list function to unpack XML as list, mutate into data frame. (ReadTQDReport.R)
-> Works for one size XML (DIC.xml) but not larger complex data (OffshoreWater.xml)

Repository contents:
TQD Script = Script to read XML file from TargetLynx into R data frame

DIC data = XML data that works with TQD script

Offshore water xml = XML data that does not work with script; when fed into script produces data frame with inappropriate values for area and concentration columns for all compounds beyond the first 4. Grabbing and binding the wrong values. 

Offshore water text = text document demonstrating that ReadTQDReport.R  is populating area and concentration columns with incorrect numbers. 

Ex: For Sample AED-0031514-PFAS-18Jul19-001, and Compound = PFBS, Raw.Response should equal 410 and ISTD.Response should equal 3495 BUT the data frame generated using the list approach inappropriately designates these fields with Raw.Response = 3495 and ISTD.Response = 582, suggesting somewhere the row and column binds get mismatched. PFBA, PFBA-13C4, PFPeA, and M5PFPeA-13C5 are populated correctly, with the remaining rows in the dataframe populated incorrectly. 

The two XML outputs are from the same software, but contain different amounts of information. 
