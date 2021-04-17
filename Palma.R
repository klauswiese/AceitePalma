#Dataset para ver aceite de palma
#https://developers.google.com/earth-engine/datasets/catalog/BIOPAMA_GlobalOilPalm_v1
#K. Wiese 15 de abril 2021

#definir directorio de trabajo
setwd("~/git/AceitePalma/")

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
#Import the dataset; a collection of composite granules from 2019.
dataset <- ee$ImageCollection('BIOPAMA/GlobalOilPalm/v1')

#Select the classification band.
opClass <- dataset$select('classification')

#Mosaic all of the granules into a single image.
mosaic <- opClass$mosaic()

#paleta de colores
VosParams <- list(palette = c(
  'ff0000','ef00ff', '696969'),
  min = 1,
  max = 3)

#Create a mask to add transparency to non-oil palm plantation class pixels.
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
    name = "Palma para Aceite de Oliva"
  )




