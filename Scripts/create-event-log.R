
# Setup -------------------------------------------------------------------

library(bupaverse)
library(tidyverse)

# Read data ---------------------------------------------------------------

source("./Scripts/ingest-roster.R")
source("./Scripts/ingest-play-by-play.R")

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







