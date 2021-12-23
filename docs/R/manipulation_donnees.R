# Package requis : ------------------------------------------------------------

library(countrycode)

# 1. Manipulation des données : -----------------------------------------------

## Ajuster pour obtenir le bon type de variables :

vaccination_data$date <- as_date(vaccination_data$date)

## Sous-groupe contenent seulement les données "World", qui seront pertinentes plus tard :

world_vaccination_data <- vaccination_data %>% 
    filter(str_detect(iso_code, "OWID_WRL")) %>% 
    select(-iso_code)                             #suppession de cette colonne, car elle est similaire à "location".

## Retirer les subdivisions "OWID" qui ne sont pas utiles :

vaccination_data <- vaccination_data %>% 
    filter(!str_detect(iso_code, "OWID_ENG|OWID_HIC|OWID_EUN|OWID_KOS|OWID_LIC|OWID_LMC|OWID_CYN|OWID_NIR|OWID_SCT|OWID_UMC|OWID_WLS|OWID_WRL"))

## Modifier le nom de la dernier colonne de "gdp_countries_data" :

colnames(gdp_countries_data) <- c("geo", "name", "time", "Income per person", "GDP total", "GDP per capita growth (%)")

## 2. Sélectionner les observations des années 2020 et 2021 puisque le vaccination ne concerne que ces années : ---------------------------------------------------

population_countries_data <- population_countries_data %>% 
    filter(str_detect(time, "2020|2021"))
    
population_regions_data <- population_regions_data %>% 
    filter(str_detect(time, "2020|2021"))

population_world_data <- population_world_data %>% 
    filter(str_detect(time, "2020|2021")) %>% 
    select(-geo)                                #suppession de cette colonne, car elle est similaire à "name".

gdp_countries_data <- gdp_countries_data %>% 
    filter(str_detect(time, "2020|2021"))

gdp_regions_data <- gdp_regions_data %>% 
    filter(str_detect(time, "2020|2021"))

gdp_world_data <- gdp_world_data %>% 
    filter(str_detect(time, "2020|2021")) %>% 
    select(-geo)

expectancy_countries_data <- expectancy_countries_data %>% 
    filter(str_detect(time, "2020|2021"))

expectancy_regions_data <- expectancy_regions_data %>% 
    filter(str_detect(time, "2020|2021"))

expectancy_world_data <- expectancy_world_data %>% 
    filter(str_detect(time, "2020|2021")) %>% 
    select(-geo)

## 2.1. Extraire l'année de "vaccination_data" et de "world_vaccination_data" :

vaccination_data <- vaccination_data %>% 
    mutate(time = year(date)) %>%         #pour joindre avec les autres banques de données.
    relocate(time, .after = "date")

world_vaccination_data <- world_vaccination_data %>% 
    mutate(time = year(date)) %>%         
    relocate(time, .after = "date")

## 3. Nettoyer la banque de données "countries_info_data" : ----------------------------------------------------

countries_info_data <- countries_info_data %>% 
    select(c("name", "alpha.3", "region")) %>% 
    rename(c(geo = alpha.3, continent = region)) 

countries_info_data$name <- str_replace_all(countries_info_data$name, c("Viet Nam" = "Vietnam",
                                                                        "United States of America" = "United States",
                                                                        "United Kingdom of Great Britain and Northern Ireland" = "United Kingdom",
                                                                        "Timor-Leste" = "Timor",
                                                                        "Tanzania, United Republic of" = "Tanzania",
                                                                        "Taiwan, Province of China" = "Taiwan",
                                                                        "Syrian Arab Republic" = "Syria",
                                                                        "Korea, Republic of" = "South Korea",
                                                                        "Saint Helena, Ascension and Tristan da Cunha" = "Saint Helena",
                                                                        "Russian Federation" = "Russia",
                                                                        "Palestine, State of" = "Palestine",
                                                                        "Moldova, Republic of" = "Moldova",
                                                                        "Lao People's Democratic Republic" = "Laos",
                                                                        "Faroe Islands" = "Faeroe Islands",
                                                                        "Congo, Democratic Republic of the" = "Democratic Republic of Congo",
                                                                        "Curaçao" = "Curacao",
                                                                        "Côte d'Ivoire" = "Cote d'Ivoire",
                                                                        "Cabo Verde" = "Cape Verde",
                                                                        "Brunei Darussalam" = "Brunei",
                                                                        "Bonaire, Sint Eustatius and Saba" = "Bonaire Sint Eustatius and Saba",
                                                                        "Falkland Islands [(]Malvinas[)]" = "Falkland Islands",
                                                                        "Virgin Islands [(]British[)]" = "British Virgin Islands",
                                                                        "Venezuela [(]Bolivarian Republic of[)]" = "Venezuela",
                                                                        "Iran [(]Islamic Republic of[)]" = "Iran",
                                                                        "Bolivia [(]Plurinational State of[)]" = "Bolivia")) #il faut utiliser les [] pour échapper aux ().

## 3.1. Diviser les données liées à la vaccination (continents vs. pays) :

vaccination_data <- rename(vaccination_data, c(name = location, geo = iso_code)) #pour harmoniser les données, il faut modifier les noms des variables "location" et "iso_code".

vaccination_countries_data <- vaccination_data %>% 
    filter(!str_detect(geo, "OWID_"))

vaccination_regions_data <- vaccination_data %>% 
    filter(str_detect(geo, "OWID_"))

## 3.2. Harmoniser les observations provenant des divers continents :

vaccination_regions_data <- vaccination_regions_data %>% 
    mutate(name = str_replace_all(name, "North America|South America", "americas")) #fusionner l'Amérique du Nord et du Sud.

vaccination_regions_data <- vaccination_regions_data %>% 
    mutate(geo = str_replace_all(geo, "OWID_NAM|OWID_SAM", "The Americas")) %>% 
    mutate(geo = str_replace_all(geo, "OWID_AFR", "Africa")) %>% 
    mutate(geo = str_replace_all(geo, "OWID_ASI", "Asia")) %>% 
    mutate(geo = str_replace_all(geo, "OWID_EUR", "Europe")) %>% 
    mutate(geo = str_replace_all(geo, "OWID_OCE", "Oceania"))

## 3.3. Harmoniser les variables "geo" des banques de données "countries" :

population_countries_data$geo <- str_to_upper(population_countries_data$geo)

gdp_countries_data$geo <- str_to_upper(gdp_countries_data$geo)

expectancy_countries_data$geo <- str_to_upper(expectancy_countries_data$geo)

## 4. Joindre les banques de données de type "countries" : -----------------------------------------------------------------------

## 4.1. Ajout de la colonne "continent" :

countries_main_df <- left_join(vaccination_countries_data,
                               countries_info_data,
                               by = c("name", "geo")) %>% 
    relocate(continent, .before = name)

## 4.2. Ajout des données "population", "gdp" et "life-expectancy" :

countries_main_df <- left_join(countries_main_df, 
                               population_countries_data,
                               by = c("name", "geo", "time"))

countries_main_df <- left_join(countries_main_df, 
                               gdp_countries_data,
                               by = c("name", "geo", "time"))

countries_main_df <- left_join(countries_main_df,
                               expectancy_countries_data,
                               by = c("name", "geo", "time"))

## 5. Supprimer les colonnes "name" puisqu'elles sont similaires aux colonnes "geo" : ---------------------------------------------

vaccination_regions_data <- vaccination_regions_data %>% 
    select(-geo)

population_regions_data <- population_regions_data %>% 
    select(-geo)

gdp_regions_data <- gdp_regions_data %>% 
    select(-geo)

expectancy_regions_data <- expectancy_regions_data %>% 
    select(-geo)

## 5.1. Harmoniser la variable "name" de la banque de données liées à la vaccination :

vaccination_regions_data <- vaccination_regions_data %>% 
    mutate(name = str_replace_all(name, "americas", "The Americas"))

## 6. Joindre les banques de données de type "regions" : --------------------------------------------------------------------

regions_main_df <- left_join(vaccination_regions_data, 
                             population_regions_data,
                             by = c("name", "time"))

regions_main_df <- left_join(regions_main_df,
                             gdp_regions_data,
                             by = c("name", "time"))

regions_main_df <- left_join(regions_main_df,
                             expectancy_regions_data,
                             by = c("name", "time"))

## 7. Changer le nom de la variable "location" : -------------------------------------------------------------------------

world_vaccination_data <- world_vaccination_data %>% 
    rename(name = location)

## 7.1. Joindre les banques de données de type "world" :

world_main_df <- left_join(world_vaccination_data,
                           population_world_data,
                           by = c("name", "time"))

world_main_df <- left_join(world_main_df, 
                           gdp_world_data,
                           by = c("name", "time"))

world_main_df <- left_join(world_main_df,
                           expectancy_world_data,
                           by = c("name", "time"))

## 8. Sauvegarder les données nettoyées dans "data/processed" : ----------------------------------------------------------
### Ces fichiers sont mis à jour dès que le script est exécuté.

write.csv(countries_main_df, "data/processed/countries-dataframe-clean.csv") 

write.csv(regions_main_df, "data/processed/continents-dataframe-clean.csv")

write.csv(world_main_df, "data/processed/world-dataframe-clean.csv")

## 9. Retirer les objets qui ne sont plus utiles : -----------------------------------------------------------------------

remove(countries_info_data,
       expectancy_countries_data,
       expectancy_regions_data,
       expectancy_world_data,
       gdp_countries_data,
       gdp_regions_data,
       gdp_world_data, 
       population_countries_data,
       population_regions_data, 
       population_world_data,
       vaccination_countries_data,
       vaccination_regions_data, 
       vaccination_data,
       world_vaccination_data,
       countries_main_df,
       regions_main_df,
       world_main_df)
