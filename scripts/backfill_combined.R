# backfill_combined.R

library(rvest)
library(dplyr)
library(lubridate)
library(readr)
library(stringr)

data_file <- "data-processed/bestsellers-combined.rds"

# Load existing dataset
bestsellers <- read_rds(data_file)

# Identify the first and last weeks in the dataset
last_date <- max(bestsellers$week)     # newest week you already scraped
first_date <- min(bestsellers$week)    # earliest week in your dataset

# Figure out if there are missing weeks
# We want everything between the last date in the old run and the current last_date
# Example: if old last_date was 2025-07-20, but now you already scraped 2025-09-14,
# then we need 2025-07-27, 2025-08-03, ..., 2025-09-07
missing_weeks <- seq(min(bestsellers$week), max(bestsellers$week), by = "7 days")

# Keep only weeks not already in the dataset
already_have <- unique(bestsellers$week)
missing_weeks <- setdiff(missing_weeks, already_have)

for (week_date in missing_weeks) {
  url <- sprintf(
    "https://www.nytimes.com/books/best-sellers/%s/combined-print-and-e-book-fiction/",
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
    print(paste("Added missing week:", week_date))
  } else {
    print(paste("No data found for:", week_date))
  }
}

# Save updated dataset
write_rds(bestsellers, data_file)
write_csv(bestsellers, "data-processed/bestsellers-combined.csv")

print("Backfill complete!")
