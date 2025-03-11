# Load libraries
library(readr)
library(tidyverse)
library(janitor)
library(lubridate)
library(rvest)

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

# Calculate next week's date (ensures we're only scraping new data)
current_date <- Sys.Date()
next_sunday <- current_date + (8 - wday(current_date))

# Check if data needs updating
if (next_sunday > last_date) {
  url <- sprintf("https://www.nytimes.com/books/best-sellers/%s/hardcover-fiction/", format(next_sunday, "%Y/%m/%d"))
  page <- read_html(url)
  
  titles <- page %>% html_nodes(".css-2jegzb") %>% html_text()
  authors <- page %>% html_nodes(".css-1aaqvca") %>% html_text()
  publishers <- page %>% html_nodes(".css-1w6oav3") %>% html_text()
  descriptions <- page %>% html_nodes(".css-17af87k") %>% html_text()
  
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
