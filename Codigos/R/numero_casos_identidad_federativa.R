
# Load necessary libraries
library(dplyr)
library(readr)
library(ggplot2)
library(tidyr)

# Define the base path to the directory containing the datasets
base_path <- "/Users/ariadnamanzanosperez/Downloads/Proyecto_2/Dengue/datos_por_año_dengue"

# Load the datasets for each year
combined_dataset_2021 <- read_csv(file.path(base_path, "combined_dataset_2021.csv"))
combined_dataset_2022 <- read_csv(file.path(base_path, "combined_dataset_2022.csv"))
combined_dataset_2023 <- read_csv(file.path(base_path, "combined_dataset_2023.csv"))


# Add a year column to each dataset
combined_dataset_2021 <- combined_dataset_2021 %>% mutate(YEAR = 2021)
combined_dataset_2022 <- combined_dataset_2022 %>% mutate(YEAR = 2022)
combined_dataset_2023 <- combined_dataset_2023 %>% mutate(YEAR = 2023)



# Combine all datasets
all_data <- bind_rows(combined_dataset_2021, combined_dataset_2022, combined_dataset_2023)

# Convert ENTIDAD_ASIG to numeric
all_data <- all_data %>%
  mutate(ENTIDAD_ASIG = as.numeric(ENTIDAD_ASIG))

# Create a mapping of CLAVE_ENTIDAD to ENTIDAD_FEDERATIVA
entidad_mapping <- data.frame(
  CLAVE_ENTIDAD = c(1:32, 33, 34, 35, 97, 98, 99),
  ENTIDAD_FEDERATIVA = c(
    "AGUASCALIENTES", "BAJA CALIFORNIA", "BAJA CALIFORNIA SUR", "CAMPECHE", "COAHUILA DE ZARAGOZA", 
    "COLIMA", "CHIAPAS", "CHIHUAHUA", "CIUDAD DE MÉXICO", "DURANGO", "GUANAJUATO", "GUERRERO", 
    "HIDALGO", "JALISCO", "MÉXICO", "MICHOACÁN DE OCAMPO", "MORELOS", "NAYARIT", "NUEVO LEÓN", 
    "OAXACA", "PUEBLA", "QUERÉTARO", "QUINTANA ROO", "SAN LUIS POTOSÍ", "SINALOA", "SONORA", 
    "TABASCO", "TAMAULIPAS", "TLAXCALA", "VERACRUZ DE IGNACIO DE LA LLAVE", "YUCATÁN", "ZACATECAS",
    "ESTADOS UNIDOS DE AMERICA", "OTROS PAISES DE LATINOAMERICA", "OTROS PAISES", "NO APLICA", 
    "SE IGNORA", "NO ESPECIFICADO"
  )
)

# Ensure all possible values of ENTIDAD_ASIG are included
all_possible_entidades <- expand.grid(YEAR = unique(all_data$YEAR), CLAVE_ENTIDAD = entidad_mapping$CLAVE_ENTIDAD)

# Count occurrences of each `ENTIDAD_ASIG` for each year
entidad_counts <- all_data %>%
  group_by(YEAR, ENTIDAD_ASIG) %>%
  summarise(count = n(), .groups = "drop") %>%
  right_join(all_possible_entidades, by = c("YEAR", "ENTIDAD_ASIG" = "CLAVE_ENTIDAD")) %>%
  replace_na(list(count = 0)) %>%
  left_join(entidad_mapping, by = c("ENTIDAD_ASIG" = "CLAVE_ENTIDAD"))

# Replace NA values in ENTIDAD_FEDERATIVA with "UNKNOWN" (if any)
entidad_counts$ENTIDAD_FEDERATIVA[is.na(entidad_counts$ENTIDAD_FEDERATIVA)] <- "UNKNOWN"

# Order ENTIDAD_FEDERATIVA by CLAVE_ENTIDAD
entidad_counts$ENTIDAD_FEDERATIVA <- factor(entidad_counts$ENTIDAD_FEDERATIVA, levels = entidad_mapping$ENTIDAD_FEDERATIVA[order(entidad_mapping$CLAVE_ENTIDAD)])

# Create the plot
ggplot(entidad_counts, aes(x = ENTIDAD_FEDERATIVA, y = count, fill = as.factor(YEAR))) +
  geom_bar(stat = "identity") +
  scale_fill_brewer() +
  labs(title = "Número de casos por entidad federativa y año",
       x = "ENTIDAD FEDERATIVA",
       y = "CANTIDAD DE CASOS",
       fill = "AÑO") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
  scale_y_continuous(labels = scales::comma)

###

# Count occurrences of each `ENTIDAD_ASIG` for each year
entidad_counts <- all_data %>%
  group_by(YEAR, ENTIDAD_ASIG) %>%
  summarise(count = n(), .groups = "drop") %>%
  left_join(entidad_mapping, by = c("ENTIDAD_ASIG" = "CLAVE_ENTIDAD"))

# Replace NA values in ENTIDAD_FEDERATIVA with "UNKNOWN" (if any)
entidad_counts$ENTIDAD_FEDERATIVA[is.na(entidad_counts$ENTIDAD_FEDERATIVA)] <- "UNKNOWN"

# Pivot the data to have years as columns
pivoted_data <- entidad_counts %>%
  select(YEAR, ENTIDAD_FEDERATIVA, count) %>%
  pivot_wider(names_from = YEAR, values_from = count, values_fill = list(count = 0))

# Save the pivoted dataset to a CSV file
path <- "/Users/ariadnamanzanosperez/Downloads/Proyecto_2/Dengue/datos_resumen_para_presentacion"

output_path_pivoted <- file.path(path, "Casos identidad federativa.csv")
write_csv(pivoted_data, output_path_pivoted)

# Display the first few rows of the pivoted dataset
print(head(pivoted_data))




######



