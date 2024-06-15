
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


# Get row references for quarters
quarter_rows <- map(play_by_play_raw, ~get_quarter_row_indicies(.x))


# Quarter 1 selected for game pbp_2024_06_06
play_by_play_raw$pbp_2024_06_06[quarter_rows$pbp_2024_06_06[1, "min"]:quarter_rows$pbp_2024_06_06[1, "max"], ]




# Cleanup -----------------------------------------------------------------

rm(roster_html)




#https://www.basketball-reference.com/boxscores/pbp/202406060BOS.html
#https://www.basketball-reference.com/boxscores/pbp/202406090BOS.html

# 12, 14, 17, 20, 23