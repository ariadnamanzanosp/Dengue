# Cargar las librerías necesarias
library(ggplot2)
library(gridExtra)
library(tidyverse)
library(grid)  # Necesario para agregar el título

# Crear el directorio si no existe
output_dir <- "/Users/ariadnamanzanosperez/Downloads/Proyecto_2/Dengue/imagenes/Regrecion_ambas"
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

# Definir la función para crear y guardar los gráficos por estado
create_state_plots <- function(state) {
  # Definir la ruta del archivo
  file_path <- paste0("/Users/ariadnamanzanosperez/Downloads/Proyecto_2/Dengue/dengue_temperaturas_datasets_r/PRUEBA/dengue_", state, "_final.csv")
  
  # Verificar si el archivo existe
  if (!file.exists(file_path)) {
    cat("File not found:", file_path, "\n")
    return(NULL)
  }
  
  # Cargar los datos
  data <- read.csv(file_path)
  
  # Imprimir los nombres de las columnas para verificación
  print(names(data))
  
  # Verificar que las columnas necesarias existen
  required_columns <- c("DENGUE_2021", "DENGUE_2022", "DENGUE_2023", 
                        "tem_me_2021", "tem_me_2022", "tem_me_2023", 
                        "pre_2021", "pre_2022", "pre_2023")
  if (!all(required_columns %in% names(data))) {
    cat("Error: The required columns are not present in the data for state:", state, "\n")
    return(NULL)
  }
  
  # Transformar los datos para tener una columna común de Dengue, Temperatura y Precipitación
  data_long <- data %>%
    pivot_longer(cols = starts_with("DENGUE"), names_to = "Year", values_to = "Dengue_number") %>%
    pivot_longer(cols = starts_with("tem_me"), names_to = "Year_temp", values_to = "Mean_Temperature") %>%
    pivot_longer(cols = starts_with("pre"), names_to = "Year_prec", values_to = "Daily_Rainfall_Total") %>%
    mutate(Year = as.factor(gsub("DENGUE_", "", Year))) %>%
    mutate(Year_temp = as.factor(gsub("tem_me_", "", Year_temp))) %>%
    mutate(Year_prec = as.factor(gsub("pre_", "", Year_prec))) %>%
    filter(Year == Year_temp & Year == Year_prec) %>% # Filtrar para mantener solo los años coincidentes
    select(Dengue_number, Mean_Temperature, Daily_Rainfall_Total, Year) %>% # Seleccionar columnas relevantes
    filter_all(all_vars(is.finite(.))) # Filtrar filas con valores no finitos
  
  # Crear el primer gráfico (Dengue vs Mean Temperature)
  plot1 <- ggplot(data_long, aes(x = Dengue_number, y = Mean_Temperature, color = Year)) +
    geom_point() +
    geom_smooth(method = "lm", se = TRUE, fill = "lightblue") + # Cambiar el color de la sombra
    labs(x = "Número de Casos de Dengue", y = "Temperatura Media (C)", color = "Año") +
    theme_minimal()
  
  # Crear el segundo gráfico (Dengue vs Daily Rainfall Total)
  plot2 <- ggplot(data_long, aes(x = Dengue_number, y = Daily_Rainfall_Total, color = Year)) +
    geom_point() +
    geom_smooth(method = "lm", se = TRUE, fill = "lightblue") + # Cambiar el color de la sombra
    labs(x = "Número de Casos de Dengue", y = "Precipitación Diaria Total (mm)", color = "Año") +
    theme_minimal()
  
  # Disponer los gráficos en una sola fila con un título
  combined_plot <- grid.arrange(plot1, plot2, ncol = 2)
  title <- textGrob(paste(state), gp = gpar(fontsize = 20, fontface = "bold"))
  final_plot <- grid.arrange(title, combined_plot, ncol = 1, heights = c(0.1, 1))
  
  # Guardar los gráficos como archivo PNG
  output_file <- paste0(output_dir, "/plots_", state, ".png")
  ggsave(output_file, plot = final_plot, width = 16, height = 8)
  
  cat("Plot saved for state:", state, "at", output_file, "\n")
}

# Lista de estados
states <- c("AGUASCALIENTES", "BAJA CALIFORNIA", "BAJA CALIFORNIA SUR", "CAMPECHE", "COAHUILA DE ZARAGOZA", 
            "COLIMA", "CHIAPAS", "CHIHUAHUA", "CIUDAD DE MÉXICO", "DURANGO", "GUANAJUATO", "GUERRERO", 
            "HIDALGO", "JALISCO", "MÉXICO", "MICHOACÁN DE OCAMPO", "MORELOS", "NAYARIT", "NUEVO LEÓN", 
            "OAXACA", "PUEBLA", "QUERÉTARO", "QUINTANA ROO", "SAN LUIS POTOSÍ", "SINALOA", "SONORA", 
            "TABASCO", "TAMAULIPAS", "TLAXCALA", "VERACRUZ DE IGNACIO DE LA LLAVE", "YUCATÁN", "ZACATECAS")

# Crear gráficos para todos los estados
for (state in states) {
  create_state_plots(state)
}
