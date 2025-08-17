# -----------------------------------------------
# Script: 06_summary_table.R
# Descripción: Genera tabla ejecutiva con indicadores clave
# Autor: Carlos Moreno
# Fecha: [fecha actual]
# -----------------------------------------------

# 1. Limpiar Environment y cargar librerías
rm(list = ls())
gc()

library(tidyverse)
library(scales)   # para formatear números bonitos

# 2. Cargar dataset limpio
clean_data <- read_csv("Cyclistic_Capstone_Files/data_processed/cleaned_data.csv", show_col_types = FALSE)

# 3. Tabla ejecutiva de indicadores clave
summary_table <- clean_data %>%
  group_by(member_casual) %>%
  summarise(
    total_viajes      = n(),
    porcentaje_viajes = n() / nrow(clean_data),
    duracion_promedio = mean(ride_length, na.rm = TRUE),
    viajes_por_dia    = n() / n_distinct(as.Date(started_at))
  ) %>%
  mutate(
    porcentaje_viajes = percent(porcentaje_viajes, accuracy = 0.1),
    duracion_promedio = round(duracion_promedio, 1),
    viajes_por_dia    = round(viajes_por_dia, 0)
  )

print(summary_table)

# 4. Guardar tabla
write_csv(summary_table, "Cyclistic_Capstone_Files/outputs/summary_table.csv")

cat("\n✅ Tabla ejecutiva guardada en outputs/summary_table.csv\n")
