
# Setup -------------------------------------------------------------------

library(bupaverse)
library(tidyverse)
library(rvest)

# Read pbp html -----------------------------------------------------------

play_by_play_html <- list(
  pbp_2024_06_06 = read_html("https://www.basketball-reference.com/boxscores/pbp/202406060BOS.html") 
 ,pbp_2024_06_09 = read_html("https://www.basketball-reference.com/boxscores/pbp/202406090BOS.html")
 #,pbp_2024_06_12 = read_html("https://www.basketball-reference.com/boxscores/pbp/202406090BOS.html")
 #,pbp_2024_06_14 = read_html("https://www.basketball-reference.com/boxscores/pbp/202406090BOS.html")
 #,pbp_2024_06_17 = read_html("https://www.basketball-reference.com/boxscores/pbp/202406090BOS.html")
 #,pbp_2024_06_20 = read_html("https://www.basketball-reference.com/boxscores/pbp/202406090BOS.html")
 #,pbp_2024_06_23 = read_html("https://www.basketball-reference.com/boxscores/pbp/202406090BOS.html")
)

# Get scorebox date
scorebox_dates <- map(play_by_play_html, ~get_scorebox_date(.x))

# Read roster html --------------------------------------------------------

roster_html <- list(
 bos_roster = read_html("https://www.basketball-reference.com/teams/BOS/2024.html"), 
 dal_roster = read_html("https://www.basketball-reference.com/teams/DAL/2024.html")
) 

# Transform roster data ---------------------------------------------------

roster_data <- map(
 # Get roster table and convert to data frame
 roster_html, ~html_element(., "table") %>% 
                    html_table()) %>% 
 bind_rows() %>% 
 janitor::clean_names() %>% 
 rename(number = no, 
        country_code = x7, 
        experience = exp) %>% 
 rowid_to_column(var = "resource_id")

# Transform pbp data ------------------------------------------------------

play_by_play_raw <- map(
 # Get play by player table and convert to data frame
 play_by_play_html, ~html_element(., "table") %>%
                         html_table(header = FALSE)) %>%
 # Select rows with times only and add quarter column
 map(~add_quarters_col(.x)) %>% 
 map(~tibble::rowid_to_column(.x, var = "order"))
 
 
 play_by_play_raw$pbp_2024_06_06 %>%
  rename(timestamp = X1) %>%
  mutate(
   timestamp = lubridate::ymd_hms(
    paste0(as.Date(scorebox_dates$pbp_2024_06_06), " 0:", timestamp)
   ),
   timediff = if_else(
    is.na(lag(timestamp, 1)),
    timestamp - timestamp,
    lag(timestamp, 1) - timestamp),
    timestamp = lubridate::ymd_hms(
scorebox_dates$pbp_2024_06_06 + timediff
      )
  )
 
 
 
 
 
 
 pbp_timestamped <-  play_by_play_raw$pbp_2024_06_06 %>%
 rename(timestamp = X1) %>%
 mutate(
  timestamp = lubridate::ymd_hms(
   paste0(scorebox_dates$pbp_2024_06_06, " 0:", timestamp)
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
 )






play_by_play_html$pbp_2024_06_06 %>% 
 html_nodes("div.scorebox_meta")


# Data transformations ----------------------------------------------------

# Add sequence number
pbp_with_quarters %<%
 
  
  
  

# Create event log --------------------------------------------------------

nba_eventlog <- nba_final_2024_game_7 %>% 
 eventlog(case_id = case_id, 
          activity_id = activity_id, 
          activity_instance_id = activity_instance_id, 
          lifecycle_id = lifecycle_id, 
          timestamp = timestamp, 
          resource_id = resource_id, 
          order = order, 
          validate = TRUE)


patients







