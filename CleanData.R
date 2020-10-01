# Purpose: To import and clean data into working condition


library(tidyverse)
library(here)
library(dplyr)


#Store path 
store_data_path <- here("Datasets", "msft.csv")
#store_data_path <- here("DSCI_301_REPOS","DSCI301-F20-Project1", "Datasets", "msft.csv")

#Read in data
store_data <- read_csv(store_data_path)

#Configure col_types (Price changed to col_number from col_character)
store_data <- read_csv(store_data_path,
                       col_types = cols(
                         Name = col_character(),
                         Rating = col_double(),
                         `No of people Rated` = col_double(),
                         Category = col_character(),
                         Date = col_character(),
                         Price = col_number()
                       )
)


#change free to 0.0
store_data <- store_data %>%
  mutate(
    Price = ifelse(is.na(Price),
                   0.0,           
                   Price        
    )
  )


#add a year and month column
store_data <- store_data %>%
  mutate(
    Date = parse_date(Date, "%d-%m-%Y"), 
    Year = as.numeric(format(Date, "%Y")),
    Month = as.numeric(format(Date, "%m"))
  ) %>%
  na.omit()

#the price is also in Rupees, which isn't very useful for us, so we shall convert to USD
store_data <- store_data %>%
  mutate(
    Price = Price / 73.76
  )