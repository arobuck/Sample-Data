### Exploreing with xml2 and xml tools package
#install.packages("devtools")
devtools::install_github('dantonnoriega/xmltools')
library(xmltools)
library(XML)
library(xml2)
library(magrittr)

# USING the xmltools package ------------------------------------------------
# load the data
?read_xml
doc <- read_xml("Offshore Water Volume Trials_18July2019_AED-0031514.xml")

nodeset <- doc %>%
  xml2::xml_children() # get top level nodeset

doc %>% 
  xml_view_tree()

doc %>% # we can also vary the depth
  xml_view_tree(depth = 2)

nodeset[3] %>%
  xml_get_paths()

#Notice divergent structure between all nodes!

## we can find all feasible paths then collapse

terminal <- doc %>% ## get all xpaths
  xml_get_paths()

terminal 

xpaths <- terminal %>% ## collapse xpaths to unique only
  unlist() %>%
  unique()
xpaths

## but what we really want is the parent node of terminal nodes.
## use the `only_terminal_parent = TRUE` to do this

terminal_parent <- doc %>% ## get all xpaths to parents of parent node
  xml_get_paths(only_terminal_parent = TRUE)

terminal_parent

terminal_xpaths <- terminal_parent %>% ## collapse xpaths to unique only
  unlist() %>%
  unique()

terminal_xpaths
#7 unique terminal paths in dataset

# xml_to_df (XML package based)
## does not dig by default
## use the terminal xpaths to get data frames
terminal_xpaths

# xml_dig_df (xml2 package based)
terminal_nodesets <- lapply(terminal_xpaths, xml2::xml_find_all, x = doc)
terminal_nodesets

?xml_dig_df

df2 <- terminal_nodesets %>%
  purrr::map(xml_dig_df, dig = TRUE, return_if_empty = "NA") %>% ## does not dig by default
  purrr::map(dplyr::bind_rows) %>% ##populates 7 disparate lists
  dplyr::bind_cols() %>% #encounters problem here; list 3 still nested!
  dplyr::mutate_all(empty_as_na)  

