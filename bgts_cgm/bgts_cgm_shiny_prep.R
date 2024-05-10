
library(rio)
library(janitor)
library(plotly)
library(tidyverse)
library(zoo)


bgts_cgm_geog <- import("bgts_cgm/diabetes_testingstrips_cgm_geog.csv") |> clean_names()

glimpse(bgts_cgm_geog)

bgts_cgm_geog <- bgts_cgm_geog |> 
  mutate(year_month2 = as.yearmon(as.character(year_month), "%Y%m"),
         year_month3 = as.character(year_month))

bgts_cgm_geog_icb <- bgts_cgm_geog |> 
  group_by(region, icb, financial_year, year_month2, year_month3, bnf_presentation, bnf_chemical_substance) |> 
  summarise(items = sum(items, na.rm = T),
            net_ingredient_cost = sum(net_ingredient_cost, na.rm = T),
            patient_count = sum(identified_patient_count_1_of_2)) |> 
  ungroup()


bgts_cgm_geog_icb <- bgts_cgm_geog_icb |> 
  mutate(region = str_to_title(region),
         icb = str_to_title(str_remove_all(icb, "NHS | INTEGRATED CARE BOARD")))


# save to rds for shiny app
saveRDS(bgts_cgm_geog_icb, "bgts_cgm/bgts_cgm_geog_icb.Rds")



bgts_cgm_geog_icb |> 
  filter(bnf_chemical_substance %in% c("Detection Sensor Interstitial Fluid/Gluc", "Glucose blood testing reagents")) |> 
  group_by(bnf_chemical_substance, icb, year_month3) |> 
  summarise(net_ingredient_cost = sum(net_ingredient_cost)) |> 
  filter(icb == "Black Country") |> 
  ggplot(aes(year_month3, net_ingredient_cost, group = bnf_chemical_substance, colour = bnf_chemical_substance)) +
  geom_line() +
  geom_point() +
  theme_minimal() +
  scale_y_continuous(labels = comma, limits = c(0, NA))
