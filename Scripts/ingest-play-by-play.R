
# Setup -------------------------------------------------------------------

library(rvest)
library(tidyverse)

# Read html ---------------------------------------------------------------

play_by_play_html <- list(
 bos_roster = read_html("https://www.basketball-reference.com/boxscores/pbp/202406060BOS.html"), 
 dal_roster = read_html("https://www.basketball-reference.com/boxscores/pbp/202406090BOS.html")
)

play_by_play_html <- read_html("https://www.basketball-reference.com/boxscores/pbp/202406060BOS.html")

# Transform data ----------------------------------------------------------


#play_by_play_raw <- 
play_by_play_html %>% 
 html_element("table") %>% 
 html_table(header = FALSE) 

quarter_1_row_location <- 3:(which(play_by_play_raw$X1 == "2nd Q")-2)
quarter_2_row_location <- (length(quarter_1_row_location)+1):(which(play_by_play_raw$X1 == "3rd Q")-1)
quarter_3_row_location <- (length(quarter_2_row_location)+1):(which(play_by_play_raw$X1 == "4th Q")-1)
#quarter_4_row_location <- 

length(quarter_1_row_location)+1

play_by_play_raw[quarter_1_row_location, ] 




play_by_play_raw[1:which(play_by_play_raw$X1 == "2nd Q")-1, ] %>% View()


play_by_play_team_1 <- play_by_play_raw[2, 2]$X2
play_by_play_team_2 <- play_by_play_raw[2, 6]$X6


play_by_play_raw %>% 
 select(1:3) %>% 
 filter(X2 != "") 
 


roster_data <- map(roster_html, ~html_element(., "table") %>% 
                    html_table()) %>% 
 bind_rows() %>% 
 janitor::clean_names() %>% 
 rename(number = no, 
        country_code = x7, 
        experience = exp) %>% 
 tibble::rowid_to_column()

# Cleanup -----------------------------------------------------------------

rm(roster_html)




#https://www.basketball-reference.com/boxscores/pbp/202406060BOS.html
#https://www.basketball-reference.com/boxscores/pbp/202406090BOS.html

# 12, 14, 17, 20, 23