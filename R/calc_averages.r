#' Calculates average values
#' 
#' @param years A character vector of years
#' @param inputtable A tbl_df table
#' @param filtreporter A reporter country
#' @return The average import quantities and values over beef products
#' @examples 
#' beef2008 <- calc_avg(years=c("2007", "2008", "2009"), inputtable=mx, filtreporter="EU28")


calc_avg <- function(years, inputtable, filtreporter){
  toreturn <- inputtable %>% 
    filter(reporter==filtreporter)  %>% 
    filter(period %in% years) %>%
    select(-reporter) %>%
    dcast(period + partner ~ variable, sum)
  
#  toreturn <- tbl_df(toreturn)
  
  toreturn  <- toreturn %>% 
    group_by(partner)  %>% 
    summarize(quant_avg=mean(QUANTITY_IN_100KG), value_avg=mean(VALUE_IN_EUROS))
  
  return(toreturn)
}




#' Calculates average values by tariff lines (hence detailed)
#' 
#' @param years A character vector of years
#' @param inputtable A tbl_df table
#' @param filtreporter A reporter country
#' @return The average import quantities and values over beef products
#' @examples 
#' beef2008 <- calc_avg(years=c("2007", "2008", "2009"), inputtable=mx, filtreporter="EU28")




calc_avg_detailed <- function(years, inputtable, filtreporter){
  toreturn <- inputtable %>% 
    filter(reporter==filtreporter)  %>% 
    filter(period %in% years) %>%
    select(-reporter) %>%
    dcast(period + partner + product ~ variable, sum)
  
  toreturn <- tbl_df(toreturn)
  
  toreturn  <- toreturn %>% 
    group_by(partner, product)  %>% 
    summarize(quant_avg=mean(QUANTITY_IN_100KG), value_avg=mean(VALUE_IN_EUROS))
  
  return(toreturn)
}