

# This script downloads historical weather data for Santa Barbara from NOAA.
# Note: The rnoaa package is being archived, so the data may be outdated.

# Check if rnoaa is installed, and install it if not
if (!requireNamespace("rnoaa", quietly = TRUE)) {
  install.packages("rnoaa")
}

# Check if ggplot2 is installed, and install it if not
if (!requireNamespace("ggplot2", quietly = TRUE)) {
  install.packages("ggplot2")
}

library(rnoaa)
library(ggplot2)

# Function to plot wind data
plot_wind_data <- function(file_path) {
  wind_data <- read.csv(file_path)
  wind_data$date <- as.Date(wind_data$date)
  
  p <- ggplot(wind_data, aes(x = date, y = awnd / 10)) +
    geom_line() +
    labs(title = "Daily Average Wind Speed in Santa Barbara",
         x = "Date",
         y = "Wind Speed (m/s)") +
    theme_minimal()
  print(p)
}

# Santa Barbara Airport GHCN station ID
station_id <- "USW00023190"

# Define the date range for the data you want to download
# Note: Data availability may be limited.
start_date <- "2025-01-01"
end_date <- "2025-01-31"

# Fetch the weather data
# This may take a few moments
print(paste("Fetching wind speed data for station:", station_id))
weather_data <- ghcnd_search(stationid = station_id, var = "AWND", date_min = start_date, date_max = end_date)

if (nrow(weather_data$awnd) > 0) {
  # Save the data to a CSV file
  output_file <- "santa_barbara_wind_speed.csv"
  file_path <- paste0("temperature/", output_file)
  write.csv(weather_data$awnd, file_path, row.names = FALSE)
  print(paste("Data saved to", output_file))

  # Plot the data
  plot_wind_data(file_path)

} else {
  print("No wind speed data found for the specified date range.")
}
