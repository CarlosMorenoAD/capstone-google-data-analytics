# -----------------------------------------------
# Script: 02_data_cleaning.R 
# Descripción: Compara estructuras, unifica columnas, combina y limpia datos
# Autor: Carlos Moreno
# Fecha: [fecha actual]
# -----------------------------------------------

# 1. Limpiar Environment y cargar librerías
rm(list = ls())
gc()

library(tidyverse)
library(lubridate)

# 2. Cargar datasets crudos (fase PREPARE)
df_2019_q1 <- read_csv("Cyclistic_Capstone_Files/data_processed/df_2019_q1_raw.csv", show_col_types = FALSE)
df_2020_q1 <- read_csv("Cyclistic_Capstone_Files/data_processed/df_2020_q1_raw.csv", show_col_types = FALSE)

# 3. Comparar nombres de columnas
cols_2019 <- colnames(df_2019_q1)
cols_2020 <- colnames(df_2020_q1)

cat("\n--- Columnas presentes en 2019 pero no en 2020 ---\n")
print(setdiff(cols_2019, cols_2020))

cat("\n--- Columnas presentes en 2020 pero no en 2019 ---\n")
print(setdiff(cols_2020, cols_2019))

# 4. Unificación de nombres y columnas para 2019
df_2019_q1 <- df_2019_q1 %>%
  rename(
    ride_id = trip_id,
    started_at = start_time,
    ended_at = end_time,
    start_station_id = from_station_id,
    start_station_name = from_station_name,
    end_station_id = to_station_id,
    end_station_name = to_station_name
  ) %>%
  mutate(
    ride_id = as.character(ride_id),
    rideable_type = NA_character_,
    start_lat = NA_real_,
    start_lng = NA_real_,
    end_lat = NA_real_,
    end_lng = NA_real_,
    member_casual = case_when(
      usertype == "Subscriber" ~ "member",
      usertype == "Customer" ~ "casual",
      TRUE ~ NA_character_
    )
  ) %>%
  select(
    ride_id, rideable_type, started_at, ended_at,
    start_station_name, start_station_id,
    end_station_name, end_station_id,
    start_lat, start_lng, end_lat, end_lng,
    member_casual, gender, birthyear
  )

# 5. Asegurar columnas y tipos en 2020
if (!"gender" %in% colnames(df_2020_q1)) {
  df_2020_q1$gender <- NA_character_
}
if (!"birthyear" %in% colnames(df_2020_q1)) {
  df_2020_q1$birthyear <- NA_real_
}

df_2020_q1 <- df_2020_q1 %>%
  mutate(
    ride_id = as.character(ride_id)
  ) %>%
  select(
    ride_id, rideable_type, started_at, ended_at,
    start_station_name, start_station_id,
    end_station_name, end_station_id,
    start_lat, start_lng, end_lat, end_lng,
    member_casual, gender, birthyear
  )

# 6. Combinar datasets
combined_raw_data <- bind_rows(df_2019_q1, df_2020_q1)

# 7. Guardar combinado estructurado
if (!dir.exists("Cyclistic_Capstone_Files/data_processed")) {
  dir.create("Cyclistic_Capstone_Files/data_processed", recursive = TRUE)
}
write_csv(combined_raw_data, "Cyclistic_Capstone_Files/data_processed/combined_raw_data.csv")
cat("\n✅ Datos combinados guardados en data_processed/combined_raw_data.csv\n")
cat("Dimensiones:", nrow(combined_raw_data), "filas ×", ncol(combined_raw_data), "columnas\n")

# ------------------------------------------------
# BLOQUE NUEVO: Limpieza profunda
# ------------------------------------------------

cat("\n--- Iniciando limpieza profunda ---\n")

clean_data <- combined_raw_data %>%
  # 1. Parsear fechas
  mutate(
    started_at = parse_date_time(started_at, orders = c("ymd HMS", "mdy HMS")),
    ended_at   = parse_date_time(ended_at, orders = c("ymd HMS", "mdy HMS"))
  ) %>%
  # 2. Calcular duración en minutos
  mutate(
    ride_length = as.numeric(difftime(ended_at, started_at, units = "mins")),
    day_of_week = wday(started_at, label = TRUE, abbr = FALSE, week_start = 1)
  ) %>%
  # 3. Filtrar registros inválidos
  filter(
    !is.na(start_station_id),
    !is.na(end_station_id),
    ride_length > 1,
    ride_length < 1440
  )

# 4. Guardar datos limpios
write_csv(clean_data, "Cyclistic_Capstone_Files/data_processed/cleaned_data.csv")

cat("\n✅ Limpieza completada. Datos guardados en data_processed/cleaned_data.csv\n")
cat("Dimensiones:", nrow(clean_data), "filas ×", ncol(clean_data), "columnas\n")

# --- Guardado robusto para RMarkdown ---
saveRDS(clean_data, "Cyclistic_Capstone_Files/data_processed/clean_data.rds")
message("✅ Archivo RDS guardado en data_processed/clean_data.rds")

