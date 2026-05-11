library(dplyr)
library(ggplot2)
library(tidyr)
library(gridExtra)

# Function to create the plots for each state and save them
create_state_plots <- function(state) {
  # Load the data
  file_path <- paste0("/Users/ariadnamanzanosperez/Downloads/Proyecto_2/Dengue/dengue_temperaturas_datasets_r/PRUEBA/dengue_", state, "_final.csv")
  
  # Check if the file exists
  if (!file.exists(file_path)) {
    cat("File not found:", file_path, "\n")
    return(NULL)
  }
  
  data <- read.csv(file_path)
  
  # Check if the necessary columns are present
  required_columns <- c("DENGUE_2021", "DENGUE_2022", "DENGUE_2023", "tem_me_2021", "tem_me_2022", "tem_me_2023")
  if (!all(required_columns %in% colnames(data))) {
    cat("Missing required columns in", state, "dataset\n")
    return(NULL)
  }
  
  # Create the plots with custom shadow color
  p1 <- ggplot(data, aes(x = DENGUE_2021, y = tem_me_2021)) +
    geom_point() +
    geom_smooth(method = "lm", se = TRUE, fill = "lightblue") +
    labs(title = paste(state, " 2021"), x = "Dengue", y = "Temperatura Media (C)")
  
  p2 <- ggplot(data, aes(x = DENGUE_2022, y = tem_me_2022)) +
    geom_point() +
    geom_smooth(method = "lm", se = TRUE, fill = "lightblue") +
    labs(title = paste(state, " 2022"), x = "Dengue", y = "Temperatura Media (C)")
  
  p3 <- ggplot(data, aes(x = DENGUE_2023, y = tem_me_2023)) +
    geom_point() +
    geom_smooth(method = "lm", se = TRUE, fill = "lightblue") +
    labs(title = paste(state, " 2023"), x = "Dengue", y = "Temperatura Media (C)")
  
  # Arrange the plots in a single row
  plot <- grid.arrange(p1, p2, p3, ncol = 3)
  
  # Save the plot
  output_file <- paste0("/Users/ariadnamanzanosperez/Downloads/Proyecto_2/Dengue/imagenes/regrecion_lineal_temperatura/", state, "_regresion_lineal.png")
  ggsave(filename = output_file, plot = plot, width = 15, height = 5)
  cat("Saved plot for", state, "at", output_file, "\n")
}

# List of states
states <- c("AGUASCALIENTES", "BAJA CALIFORNIA", "BAJA CALIFORNIA SUR", "CAMPECHE", "COAHUILA DE ZARAGOZA",
            "COLIMA", "CHIAPAS", "CHIHUAHUA", "CIUDAD DE MÉXICO", "DURANGO", "GUANAJUATO", "GUERRERO",
            "HIDALGO", "JALISCO", "MÉXICO", "MICHOACÁN DE OCAMPO", "MORELOS", "NAYARIT", "NUEVO LEÓN",
            "OAXACA", "PUEBLA", "QUERÉTARO", "QUINTANA ROO", "SAN LUIS POTOSÍ", "SINALOA", "SONORA",
            "TABASCO", "TAMAULIPAS", "TLAXCALA", "VERACRUZ DE IGNACIO DE LA LLAVE", "YUCATÁN", "ZACATECAS")

# Iterate over each state and create the plots
for (state in states) {
  create_state_plots(state)
}
