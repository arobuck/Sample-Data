setwd("~/Desktop/LCMS Data")

library(tidyverse)
library(readxl)
library(ggpubr)
library(dplyr)


check.packages <- function(package){
  new.package <- package[!(package %in% installed.packages()[, "Package"])]
  if (length(new.package)) 
    install.packages(new.package, dependencies = TRUE)
  sapply(package, require, character.only = TRUE)
}

check.packages(c("tidyverse", "readxl", "XML"))

?map

#Function to create lists and repopulate as dataframe; not XML parse, using list approach instead

readXMLQQQReport <- function(file) {
  
  #file <- "DIC test file 10-2-18_2.xml"
  
  doc3 <- xmlParse(file)
  
  xmltop <- xmlRoot(doc3)
  
  #sample.data <- xmlSApply(xmltop[[3]][[1]][[2]], xmlAttrs)
  
  list <- xmlToList(xmltop[[3]][[1]][[2]])
  
  f1 <- function(x) {
    unlist(as.list(bind_cols((map(x, dplyr::bind_rows)))))
  }
  
  f2 <- function(x) {
    map_at(x, "PEAK", .f = f1)
  }
  
  f3 <- function(x) {
    f1(f2(x))
  }
  
  f4 <- function(x) {
    map_at(x, "COMPOUND", .f = f3)
  }
  
  f5 <- function(x) {
    
    sub_df1 <- map(f4(x)[which(names(f4(x)) == "COMPOUND")], dplyr::bind_rows) %>%
      bind_rows()
    
    sub_df2 <- map(f4(x)[which(names(f4(x)) != "COMPOUND")], dplyr::bind_rows) %>%
      bind_cols()
    
    cbind(sub_df1,sub_df2)
    
  }
  
  f6 <- function(x) {
    sub_df <- map(list[which(names(list) == "SAMPLE")], f5) %>% bind_rows()
    
    attr <- as.data.frame(map(list[which(names(list) != "SAMPLE")], bind_rows))
    
    cbind(sub_df,attr)
  }
  
  unnested <- f6(list) %>% mutate(Cmp = calibref,
                                  Raw.Response = as.numeric(area1),
                                  ISTD.Response = as.numeric(area),
                                  Sample.Type = type,
                                  Sample.Name = name,
                                  Sample.ID = id,
                                  Sample.Desc = desc,
                                  Exp.Amt = as.numeric(stdconc),
                                  Peak.Status = pkflags,
                                  Batch = basename(.attrs.filename),
                                  Instr.Est = as.numeric(analconc))%>%
    select(Cmp,Raw.Response,ISTD.Response,Instr.Est,Sample.Type,Sample.Name,Sample.Desc,Sample.ID,Exp.Amt,Peak.Status,Batch) %>%
    mutate(Sample.Type = case_when(Sample.Type %in% c("Standard", "Standard Bracket Sample", "Std", "Std Bracket Sample") ~ "Standard",
                                   Sample.Type %in% c("Blank", "Blank Sample") ~ "Blank",
                                   Sample.Type %in% c("Analyte", "Unknown Sample", "Unknown") ~ "Sample",
                                   Sample.Type %in% c("QC", "QC Sample") ~ "QC"),
           ISTD.Response = ifelse(ISTD.Response == 0 , 1, ISTD.Response),
           Raw.Response = ifelse(is.na(Raw.Response), 0, Raw.Response),
           Area.Ratio = Raw.Response/ISTD.Response)
  return(unnested)
  
}

#OUTPUT <- readXMLQQQReport("FILE NAME.xml")

