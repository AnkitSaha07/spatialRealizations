# Load necessary libraries
library(utils)
library(dplyr)
library(readr)
library(tidyr)


# Specify the path to the zipped file
zip_folder <- "W:/PIK R/spatialRealizations/India_statewise_APY/apyFoodGrainsUPAG.zip"  # Change this to your zip file path after download


# Define the function to read and merge CSV files directly from a zipped folder
mergeZip_csvStatePanel <- function(zip_folder) {
  # List the contents of the zip file
  zip_contents <- unzip(zip_folder, list = TRUE)

  # Filter for CSV files
  csv_files <- zip_contents[grepl("\\.csv$", zip_contents$Name), "Name"]

  # Function to read and reframe CSV files directly from the zip archive
  read_and_reframe_csv <- function(file) {

    # Extract state from the file name (first word before "-")
    state <- sub("-.*", "", basename(file))

    # Read the CSV file
    data <- read_csv(unz(zip_folder, file), show_col_types = FALSE)  # Suppress column type messages

    # Clean column names to remove unwanted suffix # Remove the last "-XX" from column names
    colnames(data) <- gsub("-\\d{2}$", "", colnames(data))

    # Reshape the data into panel format and remove the Season variable
    panel_data <- data %>%
      select(-Season) %>%  # Explicitly remove the Season column
      pivot_longer(
        cols = -Crop,  # Exclude only the Crop column from reshaping
        names_to = c(".value", "Year"),
        names_sep = "-"  # Use "-" to separate variable names from years
      ) %>%
      mutate(
        state = state,  # Add the state variable to the dataframe
        Year = as.numeric(sub(".*-", "", Year)) + 1  # Extract year and add 1
      ) %>%
      select(state, everything())  # Move state to the first column

    return(panel_data)
  }

  # Read and merge all CSV files into a single dataframe
  merged_data <- bind_rows(lapply(csv_files, read_and_reframe_csv))

  return(merged_data)
}

# Call the function to merge and reframe the data
apyStateWiseCropWisePanel <- mergeZip_csvStatePanel(zip_folder)

# Display the structure of the panel dataframe
str(apyStateWiseCropWisePanel)

# Define the items to exclude to avoid aggregates
items_to_exclude <- c("Shree Anna /Nutri Cereals",
                      "Nutri/Coarse Cereals",
                      "Cereals",
                      "Total Pulses",
                      "Total Food Grains",
                      "Total Oil Seeds",
                      "Jute & Mesta")

# Filter out the specified items from the final dataframe
apyStateCrop <- apyStateWiseCropWisePanel %>%
  filter(!Crop %in% items_to_exclude)

# Converting production data from bales to 1000t for  "Cotton", "Jute", "Sannhemp", "Mesta"

apyStateCrop <- apyStateCrop %>%
  mutate(
    Production = case_when(
      Crop == "Cotton" ~ Production * 0.17, # Thousand Bales * 170 Kg = Thousand * 0.17 Tonnes
      Crop %in% c("Jute", "Sannhemp", "Mesta") ~ Production * 0.18, # Thousand Bales * 180 Kg = Thousand * 0.18 Tonnes
      TRUE ~ Production  # Keep original for others
    )
  )

# Display the first few rows of the filtered dataframe
head(apyStateCrop)

# Define the output file name
output_file_name <- "apyStateCrop.csv"  # Name of the output file

# Extract the directory of the zip folder
output_directory <- dirname(zip_folder)  # Get the directory of the zip file

# Define the output file path to save in the same directory as the zip folder
output_file_path <- file.path(output_directory, output_file_name)

# Export the final dataframe as a CSV file
write_csv(apyStateCrop, output_file_path)

# Print a message to confirm export
print(paste("Data exported successfully to:", output_file_path))
