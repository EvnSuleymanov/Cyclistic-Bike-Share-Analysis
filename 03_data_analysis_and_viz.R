# check how many rides were taken by each member type
# ride count and percentage by member type
member_type_difference <- cyclistic_data %>%
  group_by(member_casual) %>%
  summarise(count = n()) %>%
  mutate(percentage = round(100 * count / sum(count), 1))

# display the results
member_type_difference

# pie chart visualization for percentage of rides
ggplot(member_type_difference, aes(x = "", y = count, fill = member_casual)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar(theta = "y") +
  geom_text(aes(label = paste0(percentage, "%")), position = position_stack(vjust = 0.5)) +
  labs(title = "Percentage of Rides by Member Type") +
  theme_void()

# difference in the ride length between these two by calculating total ride time (in hours), 
# average, median, maximum, and minimum values.
# difference in ride length
ride_length_summary <- cyclistic_data %>%
  group_by(member_casual) %>%
  summarise(
    total_ride_length = sum(ride_length) / 60,
    average_ride_length = mean(ride_length),
    median_ride_length = median(ride_length),
    min_ride_length = min(ride_length),
    max_ride_length = max(ride_length)
  )

# Print the result to check
print(ride_length_summary)

# bar chart for total ride length
ggplot(ride_length_summary, aes(x = member_casual, fill = member_casual)) +
  geom_bar(aes(y = total_ride_length), stat = "identity") +
  labs(title = "Total Ride Length by Member Type", x = "Member Type", y = "Total Ride Length (hours)") +
  theme_minimal()

# bar chart for avg ride length
ggplot(ride_length_summary, aes(x = member_casual, y = average_ride_length, fill = member_casual)) +
  geom_bar(stat = "identity") +
  labs(title = "Average Ride Length by Member Type", x = "Member Type", y = "Average Ride Length (minutes)") +
  theme_minimal()

# convert *ride_weekday* into a factor to control the order of days
day_levels <- c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")
cyclistic_data$ride_weekday <- factor(cyclistic_data$ride_weekday, levels = day_levels)

# Group by member type and day of the week, and calculate the number of rides, mean and total ride length. 
weekday_summary <- cyclistic_data %>%
  group_by(member_casual, ride_weekday) %>%
  summarise(
    ride_count = n(),
    average_ride_length = mean(ride_length, na.rm = TRUE),
    total_ride_length = sum(ride_length)
  )

# Print the result to check
print(weekday_summary)

# Create a Line Chart for number of rides by day of the week
ggplot(weekday_summary, aes(x = ride_weekday, y = ride_count, group = member_casual, color = member_casual)) +
  geom_line(size = 1.2) +      # Plot lines for each member type
  geom_point(size = 3) +       # Add points for emphasis
  labs(
    title = "Number of Rides by Day of the Week for Members and Casual Riders",
    x = "Day of the Week",
    y = "Number of Rides",
    color = "Member Type"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5)
  )

# create line chart showing average ride length per day
ggplot(weekday_summary, 
       aes(x = ride_weekday, y = average_ride_length, group = member_casual, color = member_casual)) +
  geom_line(size = 1.2) +        # Plot lines for each member type
  geom_point(size = 3) +         # Add points for emphasis
  labs(
    title = "Average Ride Length by Day of the Week for Members and Casual Riders",
    x = "Day of the Week",
    y = "Average Ride Length (minutes)",
    color = "Member Type"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5)
  )

# create bar chart for total ride length by day of the week
ggplot(weekday_summary, aes(x = ride_weekday, y = total_ride_length, fill = member_casual)) +
  geom_bar(stat = "identity", position = "dodge") +  # 'dodge' to place bars side by side
  labs(
    title = "Total Ride Length by Day of the Week for Members and Casual Riders",
    x = "Day of the Week",
    y = "Total Ride Length (hours)",
    fill = "Member Type"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5)
  )

# summary for seasonal pattern
seasonal_summary <- cyclistic_data %>%
  group_by(member_casual, month) %>%
  summarise(
    ride_count = n(),
    average_ride_length = mean(ride_length, na.rm = TRUE),
    total_ride_length = sum(ride_length) / 60
  )

# Print the result to check
print(seasonal_summary)

# create line chart for ride counts by month
ggplot(seasonal_summary, aes(x = month, y = ride_count, group = member_casual, color = member_casual)) +
  geom_line(size = 1.2) +        # Create lines for each member type
  geom_point(size = 3) +         # Add points for emphasis
  labs(
    title = "Ride Counts by Month of the Year for Members and Casual Riders",
    x = "Month",
    y = "Number of Rides",
    color = "Member Type"
  ) +
  scale_x_discrete(limits = month_levels) +  # Ensure the correct month order
  scale_y_continuous(labels = scales::comma) +  # Use comma format for large numbers
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5),
    axis.text.x = element_text(angle = 45, hjust = 1)  # Rotate x-axis labels for better readability
  )

# create line chart for avg ride length by month
ggplot(seasonal_summary, aes(x = month, y = average_ride_length, group = member_casual, color = member_casual)) +
  geom_line(size = 1.2) +        # Create lines for each member type
  geom_point(size = 3) +         # Add points for emphasis
  labs(
    title = "Average Ride Length by Month of the Year for Members and Casual Riders",
    x = "Month",
    y = "Average Ride Length (mintues)",
    color = "Member Type"
  ) +
  scale_x_discrete(limits = month_levels) +  # Ensure the correct month order
  scale_y_continuous(labels = scales::comma) +  # Use comma format for large numbers
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5),
    axis.text.x = element_text(angle = 45, hjust = 1)  # Rotate x-axis labels for better readability
  )

# create line chart for total ride length
ggplot(seasonal_summary, aes(x = month, y = total_ride_length, group = member_casual, color = member_casual)) +
  geom_line(size = 1.2) +        # Create lines for each member type
  geom_point(size = 3) +         # Add points for emphasis
  labs(
    title = "Total Ride Length by Month of the Year for Members and Casual Riders",
    x = "Month",
    y = "Total Ride Length (hours)",
    color = "Member Type"
  ) +
  scale_x_discrete(limits = month_levels) +  # Ensure the correct month order
  scale_y_continuous(labels = scales::comma) +  # Use comma format for large numbers
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5),
    axis.text.x = element_text(angle = 45, hjust = 1)  # Rotate x-axis labels for better readability
  )

