# 1. Ouverture des données nettoyées : 

## 1.1. Données à l'échelle des pays :

fichier_countries <- list.files("data/processed/", pattern = "countries")

df_countries <- read.csv(paste0("data/processed/", fichier_countries), row.names = 1)

## 1.2. Données à l'échelle des continents :

fichier_continents <- list.files("data/processed/", pattern = "continents")

df_continents <- read.csv(paste0("data/processed/", fichier_continents), row.names = 1)

## 1.3. Données à l'échelle mondiale :

fichier_world <- list.files("data/processed/", pattern = "world")

df_world <- read.csv(paste0("data/processed/", fichier_world), row.names = 1)

## 2. Suppression des objets qui ne sont plus utiles :

remove(fichier_countries,
       fichier_continents,
       fichier_world)
