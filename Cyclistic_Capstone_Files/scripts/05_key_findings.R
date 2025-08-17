# -----------------------------------------------
# Script: 05_key_findings.R
# Descripción: Resumen de hallazgos clave para el caso Cyclistic
# Autor: Carlos Moreno
# Fecha: [fecha actual]
# -----------------------------------------------

# 1. Limpiar Environment y cargar librerías
rm(list = ls())
gc()

library(tidyverse)

# 2. Cargar resúmenes generados en outputs
summary_by_user <- read_csv("Cyclistic_Capstone_Files/outputs/summary_by_user.csv", show_col_types = FALSE)
summary_by_day  <- read_csv("Cyclistic_Capstone_Files/outputs/summary_by_day.csv", show_col_types = FALSE)
summary_by_bike <- read_csv("Cyclistic_Capstone_Files/outputs/summary_by_bike.csv", show_col_types = FALSE)

# 3. Hallazgos clave (texto impreso)
cat("\n--- HALLAZGOS CLAVE ---\n")

# 3.1 Diferencias en volumen y duración
cat("\n1. Volumen y duración de viajes\n")
print(summary_by_user)

# 3.2 Comportamiento por día de la semana
cat("\n2. Distribución semanal\n")
print(summary_by_day)

# 3.3 Uso por tipo de bicicleta
cat("\n3. Tipos de bicicleta\n")
print(summary_by_bike)

cat("\n✅ Hallazgos impresos en consola. Documentar estos resultados en el informe.\n")

# 4. Guardar un archivo de hallazgos en texto
write_lines(c(
  "HALLAZGOS CLAVE",
  "",
  "1. Members representan la mayoría de los viajes (más del 90%), con duración promedio corta (~11 min).",
  "   Casuals son minoría (~9%), pero realizan viajes mucho más largos (~38 min).",
  "",
  "2. Members muestran actividad alta en días laborales, reflejando uso como transporte cotidiano.",
  "   Casuals concentran sus viajes en fines de semana, reflejando uso recreativo/turístico.",
  "",
  "3. Ambos grupos usan principalmente docked_bike.",
  "   Los registros de 2019 no incluyen tipo de bicicleta, lo que genera valores NA."
), "Cyclistic_Capstone_Files/outputs/key_findings.txt")
