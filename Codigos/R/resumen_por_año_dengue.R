# Load necessary libraries
library(dplyr)
library(readr)

# Define the base path to the directory containing the datasets
base_path <- "/Users/ariadnamanzanosperez/Downloads/Proyecto_2/Dengue/datos_por_año_dengue"

# Load the datasets for each year
combined_dataset_2021 <- read_csv(file.path(base_path, "combined_dataset_2021.csv"))
combined_dataset_2022 <- read_csv(file.path(base_path, "combined_dataset_2022.csv"))
combined_dataset_2023 <- read_csv(file.path(base_path, "combined_dataset_2023.csv"))
combined_dataset_2024 <- read_csv(file.path(base_path, "combined_dataset_2024.csv"))

# Calculate the length for each dataset
length_2021 <- nrow(combined_dataset_2021)
length_2022 <- nrow(combined_dataset_2022)
length_2023 <- nrow(combined_dataset_2023)
length_2024 <- nrow(combined_dataset_2024)

# Create a new dataframe with the calculated lengths
summary_dataset <- data.frame(
  FECHA = c(2021, 2022, 2023, 2024),
  NUM_CASO_ANUAL = c(length_2021, length_2022, length_2023, length_2024)
  
)

# Save the summary dataset to a CSV file
output_path_summary <- file.path(base_path, "summary_dataset.csv")
write_csv(summary_dataset, output_path_summary)

# Display the new summary dataset
print(summary_dataset)

