

# Read data ---------------------------------------------------------------

# Get data
nba_2024_g5_pm_data <- read_csv("./Data/nba-final-2024-game-5.csv", col_names = TRUE)


nba_2024_g5_pm_data %>% 
 filter(activity_id == "pass-to-assist") %>% 
 count(resource_id, sort = TRUE, name = "assists")
