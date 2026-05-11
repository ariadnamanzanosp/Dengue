# Load necessary libraries
library(dplyr)
library(readr)
library(ggplot2)
library(tidyr)
library(magick)
# Define the base path to the directory containing the datasets
base_path <- "/Users/ariadnamanzanosperez/Downloads/Proyecto_2/Dengue/datos_resumen_para_presentacion"
base_path2 <- "/Users/ariadnamanzanosperez/Downloads/Proyecto_2/Temperaturas"

# Load the datasets
federativa_dengue <- read_csv(file.path(base_path, "Casos identidad federativa.csv"))

pre_2021 <- read_csv(file.path(base_path2, "Preci_mm_2021.csv"))
tem_me_2021 <- read_csv(file.path(base_path2, "Temp_Media_2021.csv"))

pre_2022 <- read_csv(file.path(base_path2, "Preci_mm_2022.csv"))
tem_me_2022 <- read_csv(file.path(base_path2, "Temp_Media_2022.csv"))

pre_2023 <- read_csv(file.path(base_path2, "Preci_mm_2023.csv"))
tem_me_2023 <- read_csv(file.path(base_path2, "Temp_Media_2023.csv"))

# Create a desired new dataset column 
new_data2021 <- federativa_dengue %>%
  select(ENTIDAD_FEDERATIVA, `2021`)

# Remove the last 4 rows which are not specified
new_data2021 <- new_data2021[1:(nrow(new_data2021) - 4), ]

# Calculate the sum of the column "2021"
nacional21 <- sum(new_data2021$`2021`, na.rm = TRUE)

# Add the "NACIONAL" row with the sum value
new_data2021 <- new_data2021 %>%
  bind_rows(tibble(ENTIDAD_FEDERATIVA = "NACIONAL", `2021` = nacional21))

# Rename the column "2021" to "DENGUE"
new_data2021 <- new_data2021 %>%
  rename(DENGUE = `2021`)

# Extract the "Anual" column from pre_2021 and rename it to "PRECIPITACION"
precipitacion_2021 <- pre_2021 %>%
  select(Anual) %>%
  rename(PRECIPITACION = Anual)

# Add the "TEMPERATURA_MEDIA" column to new_data2001
new_data2021 <- bind_cols(new_data2021, precipitacion_2021)

# Extract the "Anual" column from tem_me_2021 and rename it to  "TEMPERATURA_MEDIA"
tem_me_2021 <- tem_me_2021 %>%
  select(Anual) %>%
  rename(TEMPERATURA_MEDIA = Anual)
# Add the  "TEMPERATURA_MEDIA" column to new_data2001
new_data2021 <- bind_cols(new_data2021, tem_me_2021)

# Remove the last row which is "NACIONAL"
new_data2021 <- new_data2021[1:(nrow(new_data2021) - 1), ]

# Standardizing the data
data_standardized21 <- new_data2021 %>%
  mutate(across(DENGUE:TEMPERATURA_MEDIA, ~ (.-mean(.))/sd(.)))

# Check the summary of the standardized data
summary(data_standardized21)

# Melting the data for ggplot
data_long21 <- data_standardized21 %>%
  pivot_longer(cols = DENGUE:TEMPERATURA_MEDIA, names_to = "Variable", values_to = "Value")

# Creating the plot
plot<-ggplot(data_long21, aes(x = Value, y = ENTIDAD_FEDERATIVA, fill = Variable)) +
  geom_bar(stat = "identity") +
  facet_wrap(~ Variable, scales = "free_x") +
  scale_fill_brewer(palette = "Set1") + # Change the color palette here
  theme_minimal() +
  theme(
    legend.position = "none",
    panel.grid.major = element_blank(), # Remove major grid lines
    panel.grid.minor = element_blank()  # Remove minor grid lines
  ) +
  labs(title = "Valores estandarizados relación variable y estado 2021",
       x = "Valores estandarizados",
       y = "ENTIDAD")


# Save the plot
ggsave(filename = "//Users/ariadnamanzanosperez/Downloads/Proyecto_2/Dengue/imagenes/estandariza2021.png", plot = plot, width = 10, height = 8)

#########################
# Create a desired new dataset column 
new_data2022 <- federativa_dengue %>%
  select(ENTIDAD_FEDERATIVA, `2022`)

# Remove the last 4 rows which are not specified
new_data2022 <- new_data2022[1:(nrow(new_data2022) - 4), ]

# Calculate the sum of the column "2021"
nacional22 <- sum(new_data2022$`2022`, na.rm = TRUE)

# Add the "NACIONAL" row with the sum value
new_data2022 <- new_data2022 %>%
  bind_rows(tibble(ENTIDAD_FEDERATIVA = "NACIONAL", `2022` = nacional22))

# Rename the column "2021" to "DENGUE"
new_data2022 <- new_data2022 %>%
  rename(DENGUE = `2022`)

# Extract the "Anual" column from pre_2021 and rename it to "PRECIPITACION"
precipitacion_2022 <- pre_2022 %>%
  select(Anual) %>%
  rename(PRECIPITACION = Anual)

# Add the "TEMPERATURA_MEDIA" column to new_data2001
new_data2022 <- bind_cols(new_data2022, precipitacion_2022)

# Extract the "Anual" column from tem_me_2021 and rename it to  "TEMPERATURA_MEDIA"
tem_me_2022 <- tem_me_2022 %>%
  select(Anual) %>%
  rename(TEMPERATURA_MEDIA = Anual)
# Add the  "TEMPERATURA_MEDIA" column to new_data2021
new_data2022 <- bind_cols(new_data2022, tem_me_2022)



# Remove the last row which is "NACIONAL"
new_data2022 <- new_data2022[1:(nrow(new_data2022) - 1), ]

# Standardizing the data
data_standardized22 <- new_data2022 %>%
  mutate(across(DENGUE:TEMPERATURA_MEDIA, ~ (.-mean(.))/sd(.)))

# Check the summary of the standardized data
summary(data_standardized22)

# Melting the data for ggplot
data_long22 <- data_standardized22 %>%
  pivot_longer(cols = DENGUE:TEMPERATURA_MEDIA, names_to = "Variable", values_to = "Value")

# Creating the plot
plot<-ggplot(data_long22, aes(x = Value, y = ENTIDAD_FEDERATIVA, fill = Variable)) +
  geom_bar(stat = "identity") +
  facet_wrap(~ Variable, scales = "free_x") +
  scale_fill_brewer(palette = "Set1") + # Change the color palette here
  theme_minimal() +
  theme(
    legend.position = "none",
    panel.grid.major = element_blank(), # Remove major grid lines
    panel.grid.minor = element_blank()  # Remove minor grid lines
  ) +
  labs(title = "Valores estandarizados relación variable y estado 2022",
       x = "Valores estandarizados",
       y = "ENTIDAD")


# Save the plot
ggsave(filename = "//Users/ariadnamanzanosperez/Downloads/Proyecto_2/Dengue/imagenes/estandariza2022.png", plot = plot, width = 10, height = 8)
#########################
# Create a desired new dataset column 
new_data2023 <- federativa_dengue %>%
  select(ENTIDAD_FEDERATIVA, `2023`)

# Remove the last 4 rows which are not specified
new_data2023 <- new_data2023[1:(nrow(new_data2023) - 4), ]

# Calculate the sum of the column "2021"
nacional23 <- sum(new_data2023$`2023`, na.rm = TRUE)

# Add the "NACIONAL" row with the sum value
new_data2023 <- new_data2023 %>%
  bind_rows(tibble(ENTIDAD_FEDERATIVA = "NACIONAL", `2023` = nacional23))

# Rename the column "2021" to "DENGUE"
new_data2023 <- new_data2023 %>%
  rename(DENGUE = `2023`)

# Extract the "Anual" column from pre_2021 and rename it to "PRECIPITACION"
precipitacion_2023 <- pre_2023 %>%
  select(Anual) %>%
  rename(PRECIPITACION = Anual)

# Add the "TEMPERATURA_MEDIA" column to new_data2001
new_data2023 <- bind_cols(new_data2023, precipitacion_2023)

# Extract the "Anual" column from tem_me_2021 and rename it to  "TEMPERATURA_MEDIA"
tem_me_2023 <- tem_me_2023 %>%
  select(Anual) %>%
  rename(TEMPERATURA_MEDIA = Anual)
# Add the  "TEMPERATURA_MEDIA" column to new_data2021
new_data2023 <- bind_cols(new_data2023, tem_me_2023)





# Remove the last row which is "NACIONAL"
new_data2023 <- new_data2023[1:(nrow(new_data2023) - 1), ]

# Standardizing the data
data_standardized23 <- new_data2023 %>%
  mutate(across(DENGUE:TEMPERATURA_MEDIA, ~ (.-mean(.))/sd(.)))

# Check the summary of the standardized data
summary(data_standardized23)

# Melting the data for ggplot
data_long23 <- data_standardized23 %>%
  pivot_longer(cols = DENGUE:TEMPERATURA_MEDIA, names_to = "Variable", values_to = "Value")

# Creating the plot
plot<-ggplot(data_long23, aes(x = Value, y = ENTIDAD_FEDERATIVA, fill = Variable)) +
  geom_bar(stat = "identity") +
  facet_wrap(~ Variable, scales = "free_x") +
  scale_fill_brewer(palette = "Set1") + # Change the color palette here
  theme_minimal() +
  theme(
    legend.position = "none",
    panel.grid.major = element_blank(), # Remove major grid lines
    panel.grid.minor = element_blank()  # Remove minor grid lines
  ) +
  labs(title = "Valores estandarizados relación variable y estado 2023",
       x = "Valores estandarizados",
       y = "ENTIDAD")

# Save the plot
ggsave(filename = "//Users/ariadnamanzanosperez/Downloads/Proyecto_2/Dengue/imagenes/estandariza2023.png", plot = plot, width = 10, height = 8)




# for the video 
# Load necessary libraries
library(animation)
library(png)

# Define the path where images are stored
image_path <- "/Users/ariadnamanzanosperez/Downloads/Proyecto_2/Dengue/imagenes/"

# Create a video
saveVideo({
  for (i in 1:3) {
    img_file <- file.path(image_path, paste0("estandariza20", i + 20, ".png"))
    img <- readPNG(img_file)
    plot.new()
    rasterImage(img, 0, 0, 1, 1)
  }
}, video.name = file.path(image_path, "animated_plots.mp4"), interval = 3, ani.width = 1920, ani.height = 1080)





######