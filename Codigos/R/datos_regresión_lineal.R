library(dplyr)
library(tidyr)

# Path to the CSV files
csv_path1 <- "/Users/ariadnamanzanosperez/Downloads/Proyecto_2/Dengue/dengue_temperaturas_datasets_r/dengue_entidad_mes_año_resumen.csv"
csv_path2 <- "/Users/ariadnamanzanosperez/Downloads/Proyecto_2/Dengue/dengue_temperaturas_datasets_r/clima_resumen_por_entidad.csv"

# Read the CSV files into dataframes
cleaned_dataset <- read.csv(csv_path1)
combined_data <- read.csv(csv_path2)

# Create a mapping of lowercase to uppercase state names
state_mapping <- c(
  "Aguascalientes" = "AGUASCALIENTES",
  "Baja California" = "BAJA CALIFORNIA",
  "Baja California Sur" = "BAJA CALIFORNIA SUR",
  "Campeche" = "CAMPECHE",
  "Coahuila" = "COAHUILA DE ZARAGOZA",
  "Colima" = "COLIMA",
  "Chiapas" = "CHIAPAS",
  "Chihuahua" = "CHIHUAHUA",
  "Ciudad de México" = "CIUDAD DE MÉXICO",
  "Durango" = "DURANGO",
  "Guanajuato" = "GUANAJUATO",
  "Guerrero" = "GUERRERO",
  "Hidalgo" = "HIDALGO",
  "Jalisco" = "JALISCO",
  "Estado de México" = "MÉXICO",
  "Michoacán" = "MICHOACÁN DE OCAMPO",
  "Morelos" = "MORELOS",
  "Nayarit" = "NAYARIT",
  "Nuevo León" = "NUEVO LEÓN",
  "Oaxaca" = "OAXACA",
  "Puebla" = "PUEBLA",
  "Querétaro" = "QUERÉTARO",
  "Quintana Roo" = "QUINTANA ROO",
  "San Luis Potosí" = "SAN LUIS POTOSÍ",
  "Sinaloa" = "SINALOA",
  "Sonora" = "SONORA",
  "Tabasco" = "TABASCO",
  "Tamaulipas" = "TAMAULIPAS",
  "Tlaxcala" = "TLAXCALA",
  "Veracruz" = "VERACRUZ DE IGNACIO DE LA LLAVE",
  "Yucatán" = "YUCATÁN",
  "Zacatecas" = "ZACATECAS"
)

# Convert state names to uppercase in combined_data
combined_data$ESTADO <- state_mapping[match(combined_data$"Estado", names(state_mapping))]

# Remove the first two columns from combined_data
combined_data <- combined_data[,-c(1,2)]

# Print the first few rows of the updated dataframe to verify the changes
head(combined_data)

# Process cleaned_dataset for each state and save individual datasets
states <- unique(cleaned_dataset$ENTIDAD_ASIG)

for (state in states) {
  state_data <- cleaned_dataset %>% filter(ENTIDAD_ASIG == state)
  
  # Filter and separate data for each year
  dengue_2021 <- state_data %>%
    filter(YEAR == 2021) %>%
    mutate(row_id = row_number()) %>%
    select(row_id, CANTIDAD_DENGUE) %>%
    rename(DENGUE_2021 = CANTIDAD_DENGUE)
  
  dengue_2022 <- state_data %>%
    filter(YEAR == 2022) %>%
    mutate(row_id = row_number()) %>%
    select(row_id, CANTIDAD_DENGUE) %>%
    rename(DENGUE_2022 = CANTIDAD_DENGUE)
  
  dengue_2023 <- state_data %>%
    filter(YEAR == 2023) %>%
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
  
  # Filter combined_data for the current state
  state_combined_data <- combined_data %>% filter(ESTADO == state)
  
  # Create an ID column for merging
  final_dengue_dataset <- final_dengue_dataset %>% mutate(id = row_number())
  state_combined_data <- state_combined_data %>% mutate(id = row_number())
  
  # Merge the datasets by 'id'
  merged_dataset <- merge(final_dengue_dataset, state_combined_data, by = "id", all = TRUE) %>% select(-id)
  
  # Save the final merged dataset for each state
  write.csv(merged_dataset, paste0("/Users/ariadnamanzanosperez/Downloads/Proyecto_2/Dengue/dengue_temperaturas_datasets_r/PRUEBA/dengue_", state, "_final.csv"), row.names = FALSE)
}

# Print the final merged dataset for one state to verify the changes
print(head(merged_dataset))

