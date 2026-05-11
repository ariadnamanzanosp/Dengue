library(dplyr)
library(readr)

# Define the base path to the directory containing the yearly folders
base_path <- "/Users/ariadnamanzanosperez/Downloads/Proyecto_2/Dengue/datos_por_año_dengue"

# Define the months and corresponding folder names
months <- list(Enero = 1, Febrero = 2, Marzo = 3, Abril = 4, Mayo = 5, Junio = 6, Julio = 7, Agosto = 8, Septiembre = 9, Octubre = 10, Noviembre = 11, Diciembre = 12)

# Define the columns to be selected
columns_to_select <- c("ESTATUS_CASO", "ENTIDAD_ASIG")

# Initialize an empty list to store the summarized datasets
summarized_datasets <- list()

# Define the years to process
years <- c("2021", "2022", "2023", "2024")

# Loop through each year
for (year in years) {
  year_path <- file.path(base_path, year)
  
  # Loop through each month's folder
  for (month_name in names(months)) {
    month_number <- months[[month_name]]
    month_path <- file.path(year_path, month_name)
    
    # List all CSV files in the directory
    files <- list.files(path = month_path, pattern = "*.csv", full.names = TRUE)
    
    # Check if files were found
    if (length(files) == 0) {
      warning(paste("No CSV files found in the directory for", month_name, year))
      next
    }
    
    # Loop through each file, read the data, filter, select columns, and summarize
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
      
      # Summarize the data by 'ENTIDAD_ASIG'
      summarized_data <- filtered_data %>%
        group_by(ENTIDAD_ASIG) %>%
        summarise(CANTIDAD_DENGUE = n())
      
      # Add the 'MONTH' and 'YEAR' columns
      summarized_data <- summarized_data %>%
        mutate(MONTH = month_name, YEAR = year)
      
      # Add the summarized data to the list
      summarized_datasets <- append(summarized_datasets, list(summarized_data))
    }
  }
}

# Combine all the summarized datasets into one big dataset
final_combined_dataset <- dplyr::bind_rows(summarized_datasets)

# Save the final combined dataset to a CSV file
#output_path <- file.path("/Users/ariadnamanzanosperez/Downloads/Proyecto_2/Dengue", "final_combined_dataset.csv")
#write_csv(final_combined_dataset, output_path)

# Display the first few rows of the final combined dataset
print(head(final_combined_dataset))


###


# Define the mapping of CLAVE_ENTIDAD to ENTIDAD_FEDERATIVA
CLAVE_ENTIDAD <- c(1:32, 33, 34, 35, 97, 98, 99)
ENTIDAD_FEDERATIVA <- c(
  "AGUASCALIENTES", "BAJA CALIFORNIA", "BAJA CALIFORNIA SUR", "CAMPECHE", "COAHUILA DE ZARAGOZA", 
  "COLIMA", "CHIAPAS", "CHIHUAHUA", "CIUDAD DE MÉXICO", "DURANGO", "GUANAJUATO", "GUERRERO", 
  "HIDALGO", "JALISCO", "MÉXICO", "MICHOACÁN DE OCAMPO", "MORELOS", "NAYARIT", "NUEVO LEÓN", 
  "OAXACA", "PUEBLA", "QUERÉTARO", "QUINTANA ROO", "SAN LUIS POTOSÍ", "SINALOA", "SONORA", 
  "TABASCO", "TAMAULIPAS", "TLAXCALA", "VERACRUZ DE IGNACIO DE LA LLAVE", "YUCATÁN", "ZACATECAS",
  "ESTADOS UNIDOS DE AMERICA", "OTROS PAISES DE LATINOAMERICA", "OTROS PAISES", "NO APLICA", 
  "SE IGNORA", "NO ESPECIFICADO"
)

# Create a named vector for easy lookup
entidad_lookup <- setNames(ENTIDAD_FEDERATIVA, CLAVE_ENTIDAD)


# Replace 'ENTIDAD_ASIG' numbers with corresponding names
final_combined_dataset <- final_combined_dataset %>%
  mutate(ENTIDAD_ASIG = entidad_lookup[as.numeric(ENTIDAD_ASIG)])

# Display the first few rows of the updated dataset
print(head(final_combined_dataset))

######

# Define the values to be removed from 'ENTIDAD_ASIG'
values_to_remove <- c("ESTADOS UNIDOS DE AMERICA", "OTROS PAISES DE LATINOAMERICA", 
                      "OTROS PAISES", "NO APLICA", "SE IGNORA", "NO ESPECIFICADO")


# Filter out the rows with the specified values in 'ENTIDAD_ASIG'
cleaned_dataset <- final_combined_dataset %>%
  filter(!ENTIDAD_ASIG %in% values_to_remove)

# Display the first few rows of the cleaned dataset
print(head(cleaned_dataset))

# Save the summary dataset to a CSV file
base_path <- "/Users/ariadnamanzanosperez/Downloads/Proyecto_2/Dengue/dengue_temperaturas_datasets_r"
output_path_summary <- file.path(base_path, "dengue_entidad_mes_año_resumen.csv")
write_csv(cleaned_dataset, output_path_summary)


###### NEW DATA SET 


library(dplyr)
library(tidyr)
library(readr)

# Assuming 'cleaned_dataset' is already available

# Filter and separate data for each year without summarizing
dengue_2021 <- cleaned_dataset %>%
  filter(YEAR == "2021") %>%
  mutate(row_id = row_number()) %>%
  select(row_id, CANTIDAD_DENGUE) %>%
  rename(DENGUE_2021 = CANTIDAD_DENGUE)

dengue_2022 <- cleaned_dataset %>%
  filter(YEAR == "2022") %>%
  mutate(row_id = row_number()) %>%
  select(row_id, CANTIDAD_DENGUE) %>%
  rename(DENGUE_2022 = CANTIDAD_DENGUE)

dengue_2023 <- cleaned_dataset %>%
  filter(YEAR == "2023") %>%
  mutate(row_id = row_number()) %>%
  select(row_id, CANTIDAD_DENGUE) %>%
  rename(DENGUE_2023 = CANTIDAD_DENGUE)

# Combine the datasets by 'row_id'
final_dengue_dataset <- dengue_2021 %>%
  full_join(dengue_2022, by = "row_id") %>%
  full_join(dengue_2023, by = "row_id") %>%
  select(-row_id) # Remove the row_id column

# Fill NA values with 0 (if necessary)
final_dengue_dataset <- final_dengue_dataset %>%
  mutate(across(everything(), ~ tidyr::replace_na(.x, 0)))

# Display the final dataset
print(head(final_dengue_dataset))





##### Now for the dataset of the weather 


library(dplyr)
library(readr)

# Define the base path
base_path2 <- "/Users/ariadnamanzanosperez/Downloads/Proyecto_2/Temperaturas"

# Load the datasets
pre_2021 <- read_csv(file.path(base_path2, "Preci_mm_2021.csv"))
tem_me_2021 <- read_csv(file.path(base_path2, "Temp_Media_2021.csv"))

pre_2022 <- read_csv(file.path(base_path2, "Preci_mm_2022.csv"))
tem_me_2022 <- read_csv(file.path(base_path2, "Temp_Media_2022.csv"))

pre_2023 <- read_csv(file.path(base_path2, "Preci_mm_2023.csv"))
tem_me_2023 <- read_csv(file.path(base_path2, "Temp_Media_2023.csv"))

# Function to remove the column "Anual" and the row where "Nacional" is present
clean_data <- function(data) {
  data %>%
    select(-Anual) %>%       # Remove the column "Anual"
    filter(Estado != "Nacional")  # Remove the row where "Entidad" is "Nacional"
}

# Clean the datasets
pre_2021 <- clean_data(pre_2021)
tem_me_2021 <- clean_data(tem_me_2021)

pre_2022 <- clean_data(pre_2022)
tem_me_2022 <- clean_data(tem_me_2022)

pre_2023 <- clean_data(pre_2023)
tem_me_2023 <- clean_data(tem_me_2023)

# Display the first few rows of each cleaned dataset to confirm the changes
head(pre_2021)
head(tem_me_2021)

head(pre_2022)
head(tem_me_2022)

head(pre_2023)
head(tem_me_2023)



#######

# Function to reshape the data
reshape_data <- function(data, source_name) {
  data %>%
    pivot_longer(cols = -Estado, names_to = "Month", values_to = source_name)
}

# Reshape and combine the datasets
pre_2021_long <- reshape_data(pre_2021, "pre_2021")
tem_me_2021_long <- reshape_data(tem_me_2021, "tem_me_2021")

pre_2022_long <- reshape_data(pre_2022, "pre_2022")
tem_me_2022_long <- reshape_data(tem_me_2022, "tem_me_2022")

pre_2023_long <- reshape_data(pre_2023, "pre_2023")
tem_me_2023_long <- reshape_data(tem_me_2023, "tem_me_2023")

# Combine all reshaped datasets by joining them on "Estado" and "Month"
combined_data <- pre_2021_long %>%
  left_join(tem_me_2021_long, by = c("Estado", "Month")) %>%
  left_join(pre_2022_long, by = c("Estado", "Month")) %>%
  left_join(tem_me_2022_long, by = c("Estado", "Month")) %>%
  left_join(pre_2023_long, by = c("Estado", "Month")) %>%
  left_join(tem_me_2023_long, by = c("Estado", "Month"))

# Display the first few rows of the combined dataset to confirm the changes
head(combined_data)
# Save the summary dataset to a CSV file
base_path <- "/Users/ariadnamanzanosperez/Downloads/Proyecto_2/Dengue/dengue_temperaturas_datasets_r"
output_path_summary <- file.path(base_path, "clima_resumen_por_entidad.csv")
write_csv(combined_data, output_path_summary)
###########################################

# Extract the columns we need
combined_columns <- combined_data %>% select(pre_2021, tem_me_2021, pre_2022, tem_me_2022, pre_2023, tem_me_2023)



# Ensure there is a common identifier, if not, create a row index
final_dengue_dataset <- final_dengue_dataset %>% mutate(row_id = row_number())
combined_columns <- combined_columns %>% mutate(row_id = row_number())

# Perform a full join on the row index
final_combined_dataset <- final_dengue_dataset %>%
  full_join(combined_columns, by = "row_id") %>%
  select(-row_id)  # Remove the row index if it's no longer needed

# Display the first few rows of the final combined dataset to confirm the changes
head(final_combined_dataset)
# Save the summary dataset to a CSV file
base_path <- "/Users/ariadnamanzanosperez/Downloads/Proyecto_2/Dengue/dengue_temperaturas_datasets_r"
output_path_summary <- file.path(base_path, "combined_dataset_dengue_temperature.csv")
write_csv(final_combined_dataset, output_path_summary)

