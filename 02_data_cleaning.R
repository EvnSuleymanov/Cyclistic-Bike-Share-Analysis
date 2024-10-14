#delete duplicates
cyclistic_data <- combined_dataframe %>% distinct()

#check for missing values
colSums(is.na(cyclistic_data))

#delete unnecessary variables
cyclistic_data <- cyclistic_data %>% select(-c(start_lat, start_lng, end_lat, end_lng))

# check for empty strings
empty_string_check <- sapply(cyclistic_data, function(x) sum (x == ""))

# Display the result
empty_string_check

# We have a lot of empty strings in some variables
# Count rows where both 'start_station_id' and 'end_station_id' are empty strings
sum_empty_both <- cyclistic_data %>%
  filter(start_station_id == "" & end_station_id == "") %>%
  nrow()

# Display the result
sum_empty_both

# inspect the data
summary(cyclistic_data)

# check ride_id length if they are all the same length
ride_id_length <- cyclistic_data %>% filter(nchar(ride_id) != 16)

# Display the result
head(ride_id_length)

# there are only two types of values in the *rideable_type* and *member_casual* columns
# change the variable types to the **factor
#check the variables first
unique(cyclistic_data$rideable_type)
unique(cyclistic_data$member_casual)

#change the variable type
cyclistic_data <- cyclistic_data %>% 
  janitor::clean_names() %>% 
  mutate(
    rideable_type = as.factor(rideable_type),
    member_casual = as.factor(member_casual)
  )
# Display the result
str(cyclistic_data)

# change **started_at** and **ended_at** columns to date-time format
# create month level for right order of the dates (from sep 2023 to aug 2024)
month_levels <- c("September", "October", "November", "December", 
                  "January", "February", "March", "April", 
                  "May", "June", "July", "August")

# change the format
cyclistic_data <- cyclistic_data %>% mutate(
  started_at = as.POSIXct(started_at, format = "%Y-%m-%d %H:%M:%S"),
  ended_at = as.POSIXct(ended_at, format = "%Y-%m-%d %H:%M:%S"),
  month = format(started_at, "%B"),
  month = factor(month, levels = month_levels)
)

# add date month day and year columns
cyclistic_data <- cyclistic_data %>% 
  mutate(
    ride_date = as.Date(started_at),              # Extract full date
    ride_year = year(started_at),                 # Extract year
    ride_day = day(started_at),                   # Extract day of the month
    ride_weekday = wday(started_at, label = TRUE) # Extract day of the week
  )

# calculate ride length adn ride_length column
cyclistic_data <- cyclistic_data %>% mutate(
  ride_length = difftime(ended_at, started_at, units = "sec"))

# Sort by ride_length
cyclistic_data <- cyclistic_data %>% 
  arrange(ride_length)

# inspect the data if there are negative values in ride length
head(cyclistic_data)

# delete negative values
cyclistic_data <- cyclistic_data %>%
  filter(ride_length > 0)  

# convert ride_length data type from factor to numeric
cyclistic_data <- cyclistic_data %>% 
  janitor::clean_names() %>% 
  mutate(
    ride_length = as.numeric(ride_length)
    )

# delete empty strings
cyclistic_data <- cyclistic_data %>% 
  filter(start_station_id != "",
         end_station_id != "")

# removing rides less than 60 sec
cyclistic_data <- cyclistic_data %>% 
  filter(ride_length >= 60)

# convert ride_length to minutes}
cyclistic_data <- cyclistic_data %>% 
  mutate(ride_length = round(ride_length / 60, 1))