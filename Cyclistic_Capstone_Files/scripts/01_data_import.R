# -----------------------------------------------
# Script: 01_data_import.R 
# Descripción: Verifica e importa datos crudos de Cyclistic (PREPARE)
# Autor: Carlos Moreno
# Fecha: [fecha actual]
# -----------------------------------------------

# 1. Limpiar Environment y liberar memoria
rm(list = ls())
gc()

# 2. Cargar librerías necesarias
library(tidyverse)

# 3. Definir rutas de archivos
files <- c(
  "Cyclistic_Capstone_Files/data_raw/Divvy_Trips_2019_Q1.csv",
  "Cyclistic_Capstone_Files/data_raw/Divvy_Trips_2020_Q1.csv"
)

# 4. Verificar existencia de archivos
cat("Archivos encontrados en data_raw:\n")
print(list.files("Cyclistic_Capstone_Files/data_raw"))

if (all(file.exists(files))) {
  
  # 5. Cargar datasets por separado
  df_2019_q1 <- read_csv(files[1])
  df_2020_q1 <- read_csv(files[2])
  
  # 6. Chequeo rápido de estructura
  cat("\n--- Estructura 2019 Q1 ---\n")
  glimpse(df_2019_q1)
  
  cat("\n--- Estructura 2020 Q1 ---\n")
  glimpse(df_2020_q1)
  
  # 7. Guardar versiones crudas en data_processed
  if (!dir.exists("Cyclistic_Capstone_Files/data_processed")) {
    dir.create("Cyclistic_Capstone_Files/data_processed", recursive = TRUE)
  }
  write_csv(df_2019_q1, "Cyclistic_Capstone_Files/data_processed/df_2019_q1_raw.csv")
  write_csv(df_2020_q1, "Cyclistic_Capstone_Files/data_processed/df_2020_q1_raw.csv")
  
  cat("\n✅ Datos cargados y guardados individualmente en data_processed.\n")
  
} else {
  cat("\n❌ Error: Uno o más archivos no encontrados.\n")
}
