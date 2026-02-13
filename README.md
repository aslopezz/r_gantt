Antes de empezar establecer el directorio de trabajo con setwd("ruta/de/carpeta")

Esto asume que el archivo con los datos está en la misma carpeta, si está en otro lado hay que cambiar la ruta de la variable df

En la variable df lee un excel (read_excel) puede cambiar a leer csv con read.csv("archivo.csv")

En el código base no había una columna de DEPENDENCIA, si el archivo ya contiene eso puedes saltar el paso posterior a revisar la columna fecha, de la línea 24

