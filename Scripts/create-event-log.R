
# Setup -------------------------------------------------------------------

library(bupaverse)
library(tidyverse)
library(rvest)

source("./Functions/data-transformations.R")

# Read pbp html -----------------------------------------------------------

pbp_html <- list(
  pbp_2024_06_06 = read_html("https://www.basketball-reference.com/boxscores/pbp/202406060BOS.html") 
 ,pbp_2024_06_09 = read_html("https://www.basketball-reference.com/boxscores/pbp/202406090BOS.html")
 ,pbp_2024_06_12 = read_html("https://www.basketball-reference.com/boxscores/pbp/202406090BOS.html")
 ,pbp_2024_06_14 = read_html("https://www.basketball-reference.com/boxscores/pbp/202406090BOS.html")
 ,pbp_2024_06_17 = read_html("https://www.basketball-reference.com/boxscores/pbp/202406090BOS.html")
)

# Get scorebox date
scorebox_dates <- map(pbp_html, ~get_scorebox_date(.x))

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

 pbp_raw <- map(
 # Get play by player table and convert to data frame
 pbp_html, ~html_element(., "table") %>%
                         html_table(header = FALSE))
 
 
 pbp_with_quarters <- map(
 # Select rows with times only and add quarter column
  pbp_raw, ~add_quarters_col(.x)) %>% 
  map(~tibble::rowid_to_column(.x, var = "order"))

 pbp_with_timestamp <- pmap(
 # Calculate cumlulative timestamp
 list(pbp_with_quarters, scorebox_dates), ~calc_timestamp(..1, ..2))

 pbp_finals <- pbp_with_timestamp %>% map(
  ~rename(.x, 
          DAL_play = X2, 
          DAL_score_tally = X3, 
          score_board = X4,
          BOS_score_tally = X5, 
          BOS_play = X6, 
          )
  )
 
# Data transformations ----------------------------------------------------



# Create event log --------------------------------------------------------

nba_final_2024_game_5 <- read_csv("./Data/nba_final_2024_game_5.csv", col_names = TRUE)

nba_eventlog <-  eventlog(nba_final_2024_game_5,
          case_id = "case_id", 
          activity_id = "activity_id", 
          activity_instance_id = "activity_instance_id", 
          lifecycle_id = "lifecycle_id", 
          timestamp = "timestamp", 
          resource_id = "resource_id", 
          order = "order", 
          validate = TRUE)


nba_eventlog %>% 
 process_map()






















