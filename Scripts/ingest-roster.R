
# Setup -------------------------------------------------------------------

library(rvest)
library(tidyverse)

# Read html ---------------------------------------------------------------

roster_html <- list(
 bos_roster = read_html("https://www.basketball-reference.com/teams/BOS/2024.html"), 
 dal_roster = read_html("https://www.basketball-reference.com/teams/DAL/2024.html")
)

# Transform data ----------------------------------------------------------

roster_data <- map(roster_html, ~html_element(., "table") %>% 
 html_table()) %>% 
 bind_rows() %>% 
 janitor::clean_names() %>% 
 rename(number = no, 
        country_code = x7, 
        experience = exp) %>% 
 rowid_to_column()

# Cleanup -----------------------------------------------------------------

rm(roster_html)











