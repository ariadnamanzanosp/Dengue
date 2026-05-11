# Load necessary libraries
library(dplyr)
library(readr)

# Define the base path to the directory containing the monthly folders
#Just change   2024 for years needed, in this case 2021, 2022, 2023  
base_path <- "/Users/ariadnamanzanosperez/Downloads/Proyecto_2/Dengue/datos_por_año_dengue/2021"

# Define the months and corresponding folder names
months <- list(Enero = 1, Febrero = 2, Marzo = 3, Abril = 4, Mayo = 5, Junio = 6, Julio = 7, Agosto = 8, Septiembre = 9, Octubre = 10, Noviembre = 11, Diciembre = 12)

# Define the columns to be selected
columns_to_select <- c("ESTATUS_CASO", "SEXO", "EDAD_ANOS", "ENTIDAD_RES", "HABLA_LENGUA_INDIG",
                       "INDIGENA", "TIPO_PACIENTE", "HEMORRAGICOS", "DIABETES", 
                       "HIPERTENSION", "ENFERMEDAD_ULC_PEPTICA", "ENFERMEDAD_RENAL",
                       "INMUNOSUPR", "CIRROSIS_HEPATICA", "EMBARAZO", "DEFUNCION",
                       "DICTAMEN", "TOMA_MUESTRA", "RESULTADO_PCR","ENTIDAD_ASIG")

# Initialize an empty list to store the filtered datasets
filtered_datasets <- list()

# Loop through each month's folder
for (month_name in names(months)) {
  month_number <- months[[month_name]]
  month_path <- file.path(base_path, month_name)
  
  # List all CSV files in the directory
  files <- list.files(path = month_path, pattern = "*.csv", full.names = TRUE)
  
  # Check if files were found
  if (length(files) == 0) {
    warning(paste("No CSV files found in the directory for", month_name))
    next
  }
  
  # Loop through each file, read the data, filter, select columns, and add the 'month' column
  for (file in files) {
    # Print the file name being processed (for debugging)
    print(paste("Processing file:", file))
    
    # Read data ensuring all columns are read as characters
    data <- read_csv(file, col_types = cols(.default = "c"))
    
    # Check if the necessary columns exist in the data
    if (!all(columns_to_select %in% colnames(data))) {
      warning(paste("File", file, "does not contain all required columns. Skipping."))
      next
    }
    
    # Filter rows where 'ESTATUS_CASO' column has values 1 or 2
    filtered_data <- dplyr::filter(data, ESTATUS_CASO %in% c("1", "2")) %>%
      dplyr::select(all_of(columns_to_select))
    
    # Add the 'month' column with the corresponding month number
    filtered_data <- filtered_data %>%
      mutate(MES = as.character(month_number))
    
    # Add the filtered data to the list
    filtered_datasets <- append(filtered_datasets, list(filtered_data))
  }
}

# Combine all the filtered datasets into one big dataset
combined_dataset <- dplyr::bind_rows(filtered_datasets)

# Save the combined dataset to a CSV file
#Just change  _2024 for years needed, in this case _2021, _2022, _2023  
output_path <- file.path("/Users/ariadnamanzanosperez/Downloads/Proyecto_2/Dengue/datos_por_año_dengue", "combined_dataset_2021.csv")
write_csv(combined_dataset, output_path)

# Display the first few rows of the combined dataset
print(head(combined_dataset))

# Define the columns to summarize
columns_to_summarise <- c("ESTATUS_CASO", "SEXO", "EDAD_ANOS", "ENTIDAD_RES", "HABLA_LENGUA_INDIG",
                          "INDIGENA", "TIPO_PACIENTE", "HEMORRAGICOS", "DIABETES", 
                          "HIPERTENSION", "ENFERMEDAD_ULC_PEPTICA", "ENFERMEDAD_RENAL",
                          "INMUNOSUPR", "CIRROSIS_HEPATICA", "EMBARAZO", "DEFUNCION",
                          "DICTAMEN", "TOMA_MUESTRA", "RESULTADO_PCR","ENTIDAD_ASIG")
# Function to count occurrences of unique values in a column
count_unique_values <- function(data, column_name) {
  data %>%
    group_by_at(column_name) %>%
    summarise(count = n()) %>%
    arrange(desc(count))
}
# Loop through each column and print the counts
for (column_name in columns_to_summarise) {
  print(paste("Counts for", column_name))
  column_counts <- count_unique_values(combined_dataset, column_name)
  print(column_counts)3
}
