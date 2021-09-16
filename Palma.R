#Dataset para ver distribución para palma aceitera
#https://developers.google.com/earth-engine/datasets/catalog/BIOPAMA_GlobalOilPalm_v1
#K. Wiese 15 de abril 2021

#Librerias
library(rgee)
library(sf)

#Inicializacion
ee_Initialize(email = "klauswiesengine@gmail.com", drive = TRUE)

#Límites área de estudio
Honduras <- "data/HNg.gpkg" %>%
  st_read(quiet = TRUE) %>% 
  sf_as_ee()

#dataset
#Importar el dataset; una coleccions compuesta del 2019.
dataset <- ee$ImageCollection('BIOPAMA/GlobalOilPalm/v1')

#Seleccionar la banda "classification".
opClass <- dataset$select('classification')

#Crear mosaicoa a partir de todos los "granules".
mosaic <- opClass$mosaic()

#Paleta de colores
VosParams <- list(palette = c(
  'ff0000','ef00ff', '696969'),
  min = 1,
  max = 3)

#Crear mascara para dar transparencia a los pixeles que corresponden a clases diferentes a la palma aceitera.
mask <- mosaic$neq(3)
mask <- mask$where(mask$eq(0), 0.6)

#Mapa
Map$centerObject(Honduras,zoom=7)
Map$addLayer(
  eeObject = Honduras,
  name = "Honduras"
) +
  Map$addLayer(
    eeObject = mosaic$updateMask(mask),
    VosParams,
    name = "Palma para Aceite"
  )
