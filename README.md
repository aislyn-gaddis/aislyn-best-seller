# New York Times Best Seller Analysis

## Project Overview

This project scrapes, cleans, and analyzes data from two **New York Times Best Seller** lists:
- Hardcover Fiction List (1931-present)
- Combined Print & E-Book Fiction List (2011-present)

### Get the Data

- **Hardcover Fiction** (1931-present)
  - [RDS](https://github.com/aislyn-gaddis/aislyn-best-seller/blob/main/data-processed/bestsellers-hardcover.rds)
  - [CSV](https://github.com/aislyn-gaddis/aislyn-best-seller/blob/main/data-processed/bestsellers-hardcover.csv)
- **Combined Print & E-Book Fiction** (2011-present)
  - [RDS](https://github.com/aislyn-gaddis/aislyn-best-seller/blob/main/data-processed/bestsellers-combined.rds)
  - [CSV](https://github.com/aislyn-gaddis/aislyn-best-seller/blob/main/data-processed/bestsellers-combined.csv)

### Data Sources

- **Hardcover Fiction**: Web scrape merged with historical data from the [Post 45 Collective](https://data.post45.org/posts/nyt_hardcover_fiction_bestsellers/)
- **Combined Print & E-Book Fiction**: Web scrape from the [NYT Best Sellers site](https://www.nytimes.com/books/best-sellers/)

## Features

- **Automated Data Collection**: GitHub Actions automatically scrape the NYT Best Seller lists weekly
- **Historical Analysis**: Explores trends across 90+ years of bestseller data
- **Interactive Website**: Results viewable on [GitHub pages](https://aislyn-gaddis.github.io/aislyn-best-seller/)

## Getting Started

To run this project:

1. Clone this repository
2. Execute the Quarto files in numerical order:
   - `01-cleaning-hardcover.qmd` - Data cleaning for hardcover fiction
   - `02-cleaning-combined.qmd` - Data cleaning for combined list
   - `03-analysis-hardcover.qmd` - Analysis of hardcover fiction
   - `04-analysis-combined.qmd` - Analysis of combined list

## Project History

This project began as a class assignment for "Reporting with Data" with Professor Christian McDonald at The University of Texas at Austin (Spring 2023) and has been continuously improved since. In early 2025, I added GitHub Actions to automatically scrape the new list and update the data each week.

## Related Work

- [Original Class Story](https://aislyngaddis.com/what-books-top-the-new-york-times-best-sellers-list-and-why/)
- [Data Dive Podcast](https://thedragaudio.com/data-dives-investigating-the-new-york-times-bestseller-lists/) (UT Media Innovation Group)
- [Project Website](https://aislyn-gaddis.github.io/aislyn-best-seller/)

## Repository

- GitHub: [aislyn-gaddis/aislyn-best-seller](https://github.com/aislyn-gaddis/aislyn-best-seller)

## Author

**Aislyn Gaddis**
- Website: [aislyngaddis.com](https://aislyngaddis.com)
