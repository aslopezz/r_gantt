install.packages(c("readxl", "dplyr", "lubridate"))
install.packages("tidyr")
install.packages("ggplot2")
# install.packages("remotes")
remotes::install_github("giocomai/ganttrify")

library("ganttrify")
library("readxl")
library("dplyr")
library("lubridate")
library("tidyr")
library("ggplot2")

# ESTO TIENE UNA TABLA DE COLUMNAS ID CODIGO SECTOR FECHA TAREA DURACION
# si tienes 12 entradas y 3 procesos vas a tener 26 filas, 
# repites cada entrada y cambia la FECHA y TAREA, quizas duracion
df <- read_excel("gantt_fechas.xlsx")

# REVISA FORMATO DE COLUMNA FECHA
df <- df %>%
  mutate(FECHA = as.Date(FECHA))

# DEPENDENCIA SE GENERA A PARTIR DE ID, PARA VINCULAR CADA PROCESO
df <- df %>%
  arrange(CODIGO, FECHA) %>%
  # crea dependencia con ID y código
  group_by(CODIGO) %>%
  mutate(DEPENDENCY = lag(ID)) %>%
  ungroup()

cutoff_date <- as.Date("2026-01-31")

df_feb <- df %>%
  filter(FECHA <= cutoff_date)

df_feb <- df_feb %>%
  group_by(CODIGO) %>%
  mutate(DEPENDENCY = ifelse(lag(FECHA) <= cutoff_date, lag(ID), NA)) %>%
  ungroup()

df_agg <- df_feb %>%
  group_by(FECHA, TASK) %>%
  summarise(
    count = n(),      # how many elements happen on this day
    .groups = 'drop'
  ) %>%
  mutate(
    start = FECHA,
    end = FECHA + 1   # duration = 1 day
  )

df_agg <- df_agg %>%
  mutate(
    TASK = factor(
      TASK,
      levels = c("RESCATE", "MACETERO", "MONITOREO 1", "MONITOREO 2", "MONITOREO 3", "MONITOREO 4")
    )
  )

# por tarea
ggplot(df_agg, aes(x = start, xend = end, y = TASK, yend = TASK, color = TASK)) +
  geom_segment(aes(size = count)) +  # tamaño muestra cantidad de elementos
  scale_size_continuous(range = c(5, 15)) +
  labs(
    title = "Carta Gantt Actividades desde Rescate de Echinopsis chiloensis",
    x = "Fecha",
    y = "Tipo de Tarea",
    size = "Número de Elementos"
  ) +
  theme_minimal() +
  scale_x_date(date_breaks = "2 weeks", date_labels = "%d-%b")



