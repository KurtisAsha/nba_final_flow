
# Setup -------------------------------------------------------------------

library(rvest)
library(tidyverse)

# Read html ---------------------------------------------------------------

play_by_play_html <- list(
 pbp_2024_06_06 = read_html("https://www.basketball-reference.com/boxscores/pbp/202406060BOS.html"), 
 pbp_2024_06_09 = read_html("https://www.basketball-reference.com/boxscores/pbp/202406090BOS.html")
)

# Transform data ----------------------------------------------------------

# Grab html
play_by_play_raw <- map(play_by_play_html, ~html_element(., "table") %>%
                         html_table(header = FALSE))


play_by_play_html$pbp_2024_06_06 %>% 
 html_nodes("div.scorebox_meta")

# Select rows with times only and add quarter columnn

pbp_with_quarters <- map(play_by_play_raw, ~add_quarters_col(.x))

        
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

# Add sequence number


# Calculate timestamps # Add quarter columnn




# Cleanup -----------------------------------------------------------------

rm(roster_html)




#https://www.basketball-reference.com/boxscores/pbp/202406060BOS.html
#https://www.basketball-reference.com/boxscores/pbp/202406090BOS.html

# 12, 14, 17, 20, 23
