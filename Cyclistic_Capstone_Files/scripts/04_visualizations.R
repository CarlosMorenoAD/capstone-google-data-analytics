# -----------------------------------------------
# Script: 04_visualizations.R
# Descripción: Visualizaciones del análisis de Cyclistic
# Autor: Carlos Moreno
# Fecha: [fecha actual]
# -----------------------------------------------

# 1. Limpiar Environment y cargar librerías
rm(list = ls())
gc()

library(tidyverse)
library(lubridate)

# 2. Cargar dataset limpio
clean_data <- read_csv("Cyclistic_Capstone_Files/data_processed/cleaned_data.csv", show_col_types = FALSE)

# Crear carpeta de salida si no existe
if (!dir.exists("Cyclistic_Capstone_Files/outputs")) {
  dir.create("Cyclistic_Capstone_Files/outputs", recursive = TRUE)
}

# ------------------------------------------------
# 3. Gráfico: Total de viajes por tipo de usuario
# ------------------------------------------------
p1 <- clean_data %>%
  count(member_casual) %>%
  ggplot(aes(x = member_casual, y = n, fill = member_casual)) +
  geom_col() +
  labs(title = "Total de viajes por tipo de usuario",
       x = "Tipo de usuario", y = "Número de viajes") +
  theme_minimal()

ggsave("Cyclistic_Capstone_Files/outputs/total_viajes_usuario.png", p1, width = 6, height = 4)

# ------------------------------------------------
# 4. Gráfico: Distribución semanal por usuario
# ------------------------------------------------
p2 <- clean_data %>%
  group_by(member_casual, day_of_week) %>%
  summarise(total_viajes = n(), .groups = "drop") %>%
  ggplot(aes(x = day_of_week, y = total_viajes, fill = member_casual)) +
  geom_col(position = "dodge") +
  labs(title = "Viajes por día de la semana",
       x = "Día de la semana", y = "Número de viajes") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave("Cyclistic_Capstone_Files/outputs/viajes_dia_semana.png", p2, width = 7, height = 4)

# ------------------------------------------------
# 5. Gráfico: Duración promedio por usuario
# ------------------------------------------------
p3 <- clean_data %>%
  group_by(member_casual) %>%
  summarise(duracion_promedio = mean(ride_length, na.rm = TRUE)) %>%
  ggplot(aes(x = member_casual, y = duracion_promedio, fill = member_casual)) +
  geom_col() +
  labs(title = "Duración promedio de los viajes (minutos)",
       x = "Tipo de usuario", y = "Duración promedio (min)") +
  theme_minimal()

ggsave("Cyclistic_Capstone_Files/outputs/duracion_promedio_usuario.png", p3, width = 6, height = 4)

# ------------------------------------------------
# 6. Gráfico: Uso por tipo de bicicleta
# ------------------------------------------------
p4 <- clean_data %>%
  group_by(member_casual, rideable_type) %>%
  summarise(total_viajes = n(), .groups = "drop") %>%
  ggplot(aes(x = rideable_type, y = total_viajes, fill = member_casual)) +
  geom_col(position = "dodge") +
  labs(title = "Uso de bicicletas por tipo y usuario",
       x = "Tipo de bicicleta", y = "Número de viajes") +
  theme_minimal()

ggsave("Cyclistic_Capstone_Files/outputs/uso_bicicletas.png", p4, width = 7, height = 4)

# Cargar paquetes necesarios
library(knitr)
library(purrr)  # Para iterar fácilmente

# Ruta a la carpeta de outputs (ajusta si es necesario)
ruta_outputs <- "Cyclistic_Capstone_Files/outputs/"

# Listar todos los archivos PNG en la carpeta
archivos_png <- list.files(
  path = ruta_outputs,
  pattern = "\\.png$",  # Busca solo archivos con extensión .png
  full.names = TRUE     # Devuelve rutas completas
)

# Verificar si hay archivos PNG
if (length(archivos_png) == 0) {
  message("No se encontraron archivos PNG en la carpeta.")
} else {
  # Mostrar cada imagen (en consola o chunk)
  walk(archivos_png, ~ {
    cat("\n--- Mostrando:", basename(.x), "---\n")  # Título con nombre del archivo
    print(knitr::include_graphics(.x))              # Mostrar imagen
  })
}

cat("\n✅ Visualizaciones creadas en la carpeta outputs/\n")
