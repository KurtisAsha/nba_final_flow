
get_quarter_row_indicies <- function(raw_pbp){
 
 raw_pbp
 
 # Get row references for quarters
 quarters_list <- list(
 quarter_1_row_location = 3:(which(raw_pbp$X1 == "2nd Q") -2),
 quarter_2_row_location = (max(quarter_1_row_location) +5):(which(raw_pbp$X1 == "3rd Q") -2),
 quarter_3_row_location = (max(quarter_2_row_location) +5):(which(raw_pbp$X1 == "4th Q") -2),
 quarter_4_row_location = (max(quarter_3_row_location) +5):(nrow(raw_pbp) -1)
 )
 
 # Get min and max rows references for each quarter
 row_references <- data.frame(
  min = map(quarters_list, ~min(.x)) %>% 
   unlist(),
  
  max = map(quarters_list, ~max(.x)) %>% 
   unlist()
 )
 
 return(row_references)
 
}