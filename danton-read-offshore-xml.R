### Exploreing with xml2 and xml tools package
#install.packages("devtools")
#devtools::install_github('dantonnoriega/xmltools')
library(xmltools)
library(XML)
library(xml2)
library(magrittr)

# USING the xmltools package ------------------------------------------------
# load the data
?read_xml
xml_file <- "Offshore Water Volume Trials_18July2019_AED-0031514.xml"
doc <- read_xml(xml_file)

# we observe most data seems nested under:
# /QUANDATASET/GROUPDATA/GROUP/CALIBRATIONDATA
# /QUANDATASET/GROUPDATA/GROUP/SAMPLELISTDATA
doc %>%
  xml_view_tree(depth = 4)

# most of the data seems to be nested in attributes, not as node values
# e.g. METHODDATA
# node text is empty
doc %>%
  xml2::xml_find_all('/QUANDATASET/GROUPDATA/GROUP/METHODDATA') %>% 
  xml2::xml_text()
# but lots of attributes!
doc %>%
  xml2::xml_find_all('/QUANDATASET/GROUPDATA/GROUP/METHODDATA') %>% 
  xml2::xml_attrs()

# get CALIBRATIONDATA attribute and text data ------------
calib_nodes <-
  doc %>%
  xml2::xml_find_all('/QUANDATASET/GROUPDATA/GROUP/CALIBRATIONDATA') %>%
  xml2::xml_children()
length(calib_nodes)

calib_attrs <-
  calib_nodes %>%
  xml2::xml_attrs() %>%
  do.call(rbind, .)

calib_text <-
  calib_nodes %>%
  xml2::xml_text()

calib_attrs_text <- 
  cbind(calib_attrs, node_text = calib_text) %>%
  tibble::as_tibble()

# get SAMPLELISTDATA attribute and text data ------------
sample_nodes <- 
  doc %>%
  xml2::xml_find_all('/QUANDATASET/GROUPDATA/GROUP/SAMPLELISTDATA') %>%
  xml2::xml_children()
length(sample_nodes) # different lengths so we need something to merge on. `id`?

sample_attrs <-
  sample_nodes %>%
  xml2::xml_attrs() %>%
  do.call(rbind, .)

sample_text <-
  sample_nodes %>%
  xml2::xml_text()

sample_attrs_text <- cbind(sample_attrs, node_text = sample_text) %>%
  tibble::as_tibble()
