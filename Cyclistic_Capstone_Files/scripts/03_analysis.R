# -----------------------------------------------
# Script: 03_analysis.R
# Descripción: Análisis exploratorio del dataset limpio
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

# 3. Métricas clave por tipo de usuario
summary_by_user <- clean_data %>%
  group_by(member_casual) %>%
  summarise(
    total_viajes = n(),
    duracion_promedio_min = mean(ride_length, na.rm = TRUE),
    duracion_total_horas = sum(ride_length, na.rm = TRUE) / 60
  ) %>%
  arrange(desc(total_viajes))

print(summary_by_user)

# 4. Distribución por día de la semana
summary_by_day <- clean_data %>%
  group_by(member_casual, day_of_week) %>%
  summarise(
    total_viajes = n(),
    duracion_promedio_min = mean(ride_length, na.rm = TRUE)
  ) %>%
  arrange(member_casual, day_of_week)

print(summary_by_day)

# 5. Uso por tipo de bicicleta
summary_by_bike <- clean_data %>%
  group_by(member_casual, rideable_type) %>%
  summarise(
    total_viajes = n(),
    duracion_promedio_min = mean(ride_length, na.rm = TRUE)
  )

print(summary_by_bike)

# 6. Guardar resultados como CSV (opcional)
write_csv(summary_by_user, "Cyclistic_Capstone_Files/outputs/summary_by_user.csv")
write_csv(summary_by_day, "Cyclistic_Capstone_Files/outputs/summary_by_day.csv")
write_csv(summary_by_bike, "Cyclistic_Capstone_Files/outputs/summary_by_bike.csv")
