# Retrieves the rows for each quarter -------------------------------------------------------------
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

# Filters play by play data and adds relevant quarter ---------------------------------------------------
add_quarters_col <- function(play_by_play_raw) {

quarter_rows <- map(play_by_play_raw, ~get_quarter_row_indicies(.x))
 
 q1_pbp <- play_by_play_raw[quarter_rows[1, "min"]:quarter_rows[1, "max"], ] %<%
 mutate(quarter = "quarter_1"}

q2_pbp <- play_by_play_raw[quarter_rows[2, "min"]:quarter_rows[2, "max"], ] %<%
 mutate(quarter = "quarter_2"}

q3_pbp <- play_by_play_raw[quarter_rows[3, "min"]:quarter_rows[3, "max"], ] %<%
 mutate(quarter = "quarter_3"}
        
q4_pbp <- play_by_play_raw[quarter_rows[4, "min"]:quarter_rows[4, "max"], ] %<%
 mutate(quarter = "quarter_4"}

pbp_with_quarters <- bind_rows(
 q1_pbp,
 q2_pbp,
 q3_pbp,
 q4_pbp
 )

  return(pbp_with_quarters)

 }
