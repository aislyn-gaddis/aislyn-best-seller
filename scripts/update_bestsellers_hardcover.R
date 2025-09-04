# Load only the necessary libraries
library(readr)     # For reading/writing RDS and CSV files
library(dplyr)     # For bind_rows()
library(stringr)   # For str_remove_all()
library(lubridate) # For date manipulation (year(), wday())
library(rvest)     # For web scraping (read_html(), html_nodes(), html_text())

# Set file paths (🔧 Make sure these match your project structure)
data_file <- "data-processed/bestsellers-hardcover.rds"

# Load existing data
if (file.exists(data_file)) {
  bestsellers <- read_rds(data_file)
  last_date <- max(bestsellers$week)  # Get latest date in dataset
} else {
  bestsellers <- tibble()  # If no file exists, start fresh
  last_date <- as.Date("2020-12-13")  # 🔧 Change this if your start date is different
}
print(last_date)

# Calculate next week's date
current_date = Sys.Date()
day_of_week = wday(current_date)
 
# note: the list for the following week is published on Wednesdays at 7pm EST

if (day_of_week == 1) {
  next_sunday = current_date + 7
} else if (day_of_week >= 2 & day_of_week <= 3) {
   days_until_sunday = 8 - day_of_week
   next_sunday = current_date + days_until_sunday # end_date is equal to the sunday after the current_date
} else if (day_of_week >= 4 & day_of_week <= 7) {
  days_until_sunday = 8 - day_of_week
  next_sunday = current_date + days_until_sunday + 7 # end_date is equal to 2 sundays after the current_date
}
print(next_sunday) # for debugging if next_sunday value is correct

# extra loop to see if there are any missing weeks that didn't get scraped for whatever reason
missing_weeks <- seq(last_date + 7, next_sunday - 7, by = "7 days")

for (week_date in missing_weeks) {
  url <- sprintf(
    "https://www.nytimes.com/books/best-sellers/%s/hardcover-fiction/",
    format(week_date, "%Y/%m/%d")
  )
  page <- read_html(url)

  titles <- page %>% html_nodes(".css-5pe77f") %>% html_text()
  authors <- page %>% html_nodes(".css-hjukut") %>% html_text()
  publishers <- page %>% html_nodes(".css-heg334") %>% html_text()
  descriptions <- page %>% html_nodes(".css-14lubdp") %>% html_text()

  if (length(titles) > 0) {
    new_data <- tibble(
      year = year(week_date),
      week = week_date,
      rank = seq_along(titles),
      title = titles,
      author = str_remove_all(authors, "by "),
      publisher = publishers,
      description = descriptions
    )
    bestsellers <- bind_rows(bestsellers, new_data)
    print(paste("✅ Filled missing week:", week_date))
  } else {
    print(paste("⚠️ No data found for missing week:", week_date))
  }
}

# Save after backfill
write_rds(bestsellers, data_file)
write_csv(bestsellers, "data-processed/bestsellers-hardcover.csv")

# Check if data needs updating
if (next_sunday > last_date) {
  url <- sprintf("https://www.nytimes.com/books/best-sellers/%s/hardcover-fiction/", format(next_sunday, "%Y/%m/%d"))
  page <- read_html(url)
  
  titles <- page %>% html_nodes(".css-5pe77f") %>% html_text()
  authors <- page %>% html_nodes(".css-hjukut") %>% html_text()
  publishers <- page %>% html_nodes(".css-heg334") %>% html_text()
  descriptions <- page %>% html_nodes(".css-14lubdp") %>% html_text()
  
  if (length(titles) > 0) {  # Only save if scrape was successful
    new_data <- tibble(
      year = year(next_sunday),
      week = next_sunday,
      rank = seq_along(titles),
      title = titles,
      author = str_remove_all(authors, "by "),
      publisher = publishers,
      description = descriptions
    )
    
    # Append new data and save
    bestsellers_updated <- bind_rows(bestsellers, new_data)
    write_rds(bestsellers_updated, data_file)
    write_csv(bestsellers_updated, "data-processed/bestsellers-hardcover.csv")
    
    print("Hardcover bestsellers updated successfully.")
  } else {
    print("No data found for this week.")
  }
} else {
  print("No new data to update.")
}
