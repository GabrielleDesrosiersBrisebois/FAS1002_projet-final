# Packgages requis : ---------------------------------------------------------------------------------

library(tidyverse)
library(lubridate)
library(readxl)

# 1. Téléchargement des données : 

## 1.1. Our World in Data - Vaccination Data : 

### Extraire seulement la date (YYYY-MM-DD) : --------------------------------------------------------

fichier_vaccination <- list.files("data/raw/", pattern = "vaccination")

fichier_vaccination_date <- as_date(str_extract(fichier_vaccination, "\\d{4}-\\d{2}-\\d{2}"))

### Expression conditionnelle pour mettre les données à jour quotidiennement : -----------------------

if(fichier_vaccination_date != today()) {
   download.file("https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/vaccinations/vaccinations.csv",
                  destfile = paste0("data/raw/vaccination-raw-", today(), ".csv"))
   file.remove(paste0("data/raw/vaccination-raw-", fichier_vaccination_date, ".csv"))
   print("Les données liées à la vaccination ont été mises à jour")
} else {
   print("Les données liées à la vaccination sont à jour")        
}

#*Dans cette expression conditionnelle, dès que la date inscrite sur le fichier ne correspond pas à la date du jour (fonction "today()"), le fichier est téléchargé à nouveau et l'ancien est supprimé. -------------------- 



## 1.2. Gapminder - Population Dataset : 

### Extraire seulement la date (YYYY-MM-DD) : -------------------------------------------------------

fichier_population <- list.files("data/raw/", pattern = "population")

fichier_population_date <- as_date(str_extract(fichier_population, "\\d{4}-\\d{2}-\\d{2}"))

### Expression conditionnelle pour mettre les données à jour mensuellement : ------------------------

if((fichier_population_date + months(1)) < today()) {
   download.file("https://docs.google.com/spreadsheets/d/14_suWY8fCPEXV0MH7ZQMZ-KndzMVsSsA5HdR-7WqAC0/export?format=xlsx",
                  destfile = paste0("data/raw/population-raw-", today(), ".xlsx"), mode = "wb")
   file.remove(paste0("data/raw/population-raw-", fichier_population_date, ".xlsx"))
   print("Les données Gapminder-Population ont été mises à jour")
} else {
   print("Les données Gapminder-Population sont à jour")        
}

#*Dans cette expression conditionnelle, dès que la date inscrite sur le fichier ("fichier_population_date") dépasse un mois, le fichier est téléchargé à nouveau et l'ancien est supprimé. ------------------- 



## 1.3. Gapminder - GDP per capita Dataset : 

### Extraire seulement la date (YYYY-MM-DD) : --------------------------------------------------------

fichier_gdp <- list.files("data/raw/", pattern = "gdp")

fichier_gdp_date <- as_date(str_extract(fichier_gdp, "\\d{4}-\\d{2}-\\d{2}"))

### Expression conditionnelle pour mettre les données à jour mensuellement : ------------------------

if((fichier_gdp_date + months(1)) < today()) {
   download.file("https://docs.google.com/spreadsheets/d/1h3z8u0ykcUum8P9FV8EHF9fszDYr7iPDZQ-fgE3ecls/export?format=xlsx",
                 destfile = paste0("data/raw/gdp-raw-", today(), ".xlsx"), mode = "wb")
   file.remove(paste0("data/raw/gdp-raw-", fichier_gdp_date, ".xlsx"))
   print("Les données Gapminder-GDP per capita ont été mises à jour")
} else {
   print("Les données Gapminder-GDP per capita sont à jour")    
}

#*Dans cette expression conditionnelle, dès que la date inscrite sur le fichier ("fichier_gdp_date") dépasse un mois, le fichier est téléchargé à nouveau et l'ancien est supprimé. -------------------------- 



## 1.4. Gapminder - Life Expectancy : 

### Extraire seulement la date (YYYY-MM-DD) : -------------------------------------------------

fichier_expectancy <- list.files("data/raw/", pattern = "life-expectancy")

fichier_expectancy_date <- as_date(str_extract(fichier_expectancy, "\\d{4}-\\d{2}-\\d{2}"))

### Expression conditionnelle pour mettre les données à jour mensuellement : -----------------

if((fichier_expectancy_date + months(1)) < today()) {
   download.file("https://docs.google.com/spreadsheets/d/11mulzUH3_cueq-V9D5KIlo9oHE9YYZrUSeVyCin7_rM/export?format=xlsx",
                 destfile = paste0("data/raw/life-expectancy-raw-", today(), ".xlsx"), mode = "wb")
   file.remove(paste0("data/raw/life-expectancy-raw-", fichier_expectancy_date, ".xlsx"))
   print("Les données Gapminder-Life Expectancy ont été mises à jour")
} else {
   print("Les données Gapminder-Life Expectancy sont à jour")    
}

#*Dans cette expression conditionnelle, dès que la date inscrite sur le fichier ("fichier_expectancy_date") dépasse un mois, le fichier est téléchargé à nouveau et l'ancien est supprimé. -------------------------- 



## 1.5. Countries' Regional Codes : -------------------------------------------------------------

countries_info_URL <- "https://raw.githubusercontent.com/lukes/ISO-3166-Countries-with-Regional-Codes/master/all/all.csv"

countries_info_data <- read.csv(file = countries_info_URL, encoding = "UTF-8")

write.csv(countries_info_data, "data/raw/countries-information-raw.csv")




# 2. Ouvrir les banques de données : 

## 2.1. Our World in Data - Vaccination Data : ---------------------------------------------------------

fichier_vaccination <- list.files("data/raw/", pattern = "vaccination") #même objet que dans la section 1 du script, mais il est nécessaire de l'ajouter ici afin de capter les mises à jour des fichiers.

vaccination_data <- read.csv(paste0("data/raw/", fichier_vaccination))

## 2.2. Gapminder - Population Dataset : --------------------------------------------------------------

fichier_population <- list.files("data/raw/", pattern = "population")

population_world_data <- read_excel(paste0("data/raw/", fichier_population), sheet = 2) 

population_regions_data <- read_excel(paste0("data/raw/", fichier_population), sheet = 3) 

population_countries_data <- read_excel(paste0("data/raw/", fichier_population), sheet = 4)

## 2.3. Gapminder - GDP per capita Dataset : ---------------------------------------------------------

fichier_gdp <- list.files("data/raw/", pattern = "gdp")

gdp_world_data <- read_excel(paste0("data/raw/", fichier_gdp), sheet = 2)

gdp_regions_data <- read_excel(paste0("data/raw/", fichier_gdp), sheet = 3)

gdp_countries_data <- read_excel(paste0("data/raw/", fichier_gdp), sheet = 4)

## 2.4. Gapminder - Life Expectancy : -----------------------------------------------------------

fichier_expectancy <- list.files("data/raw/", pattern = "life-expectancy")

expectancy_world_data <- read_excel(paste0("data/raw/", fichier_expectancy), sheet = 2) 

expectancy_regions_data <- read_excel(paste0("data/raw/", fichier_expectancy), sheet = 3) 

expectancy_countries_data <- read_excel(paste0("data/raw/", fichier_expectancy), sheet = 4)

# 3. Retirer les objets qui ne sont plus utiles :

remove(fichier_expectancy, 
       fichier_expectancy_date,
       fichier_gdp,
       fichier_gdp_date,
       fichier_population,
       fichier_population_date, 
       fichier_vaccination,
       fichier_vaccination_date,
       countries_info_URL)
