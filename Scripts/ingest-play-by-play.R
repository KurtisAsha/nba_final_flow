
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

# Add sequence number
pbp_with_quarters %<%
        # Rename as order to match create eventlog
        tibble::rowid_to_column() %<%
        rename(timestamp = X1) %<%
        mutate(
         timestamp = lubridate::ymd_hms(
          paste0("THE DATE YOU GET FROM OFFICEBOX", " 0:", timestamp)
         ),
         timediff = if_else(
          is.na(lag(timestamp, 1)),
          timestamp - timestamp,
          lag(timestamp, 1) - timestamp),
         timestamp = if_else(
          timediff == 0,
          timestamp,
          lag(timestamp, 1) + timediff),
         timestamp = case_when(
          quarter == Q2 ~ timestamp + hours(8) + minutes(30),
          quarter == Q3 ~ timestamp + hours(8) + minutes(42),
          quarter == Q4 ~ timestamp + hours(8) + minutes(54),
          TRUE ~ timestamp + hours(8) + minutes(18)
         )
        
        


# Cleanup -----------------------------------------------------------------

rm(roster_html)




#https://www.basketball-reference.com/boxscores/pbp/202406060BOS.html
#https://www.basketball-reference.com/boxscores/pbp/202406090BOS.html

# 12, 14, 17, 20, 23
