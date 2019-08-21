# Sample-Data
Example MS MS XML data from Waters TQD

DIC data = data that works with TQD script

TQD Script = Script to read XML file from TargetLynx

Offshore water xml = output that does not work with script; when fed into script produces data frame with inappropriate values for area and concentration columns for all compounds beyond the first 4. 

Offshore water text = text document demonstrating that script is populating area and concentration columns with incorrect numbers. Ex: For Sample AED-0031514-PFAS-18Jul19-001, and Compound = PFBS, Raw.Response should equal 410 and ISTD.Response should equal 3495 BUT the data frame generated using the list approach inappropriately designates these fields with Raw.Response = 3495 and ISTD.Response = 582, suggesting somewhere the row and column binds get mismatched after the first two compounds. 
