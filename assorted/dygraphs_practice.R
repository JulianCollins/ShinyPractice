# dygraphs experiments

library(tidyverse)
library(zoo)
library(dygraphs)

dygraph(bgts_cgm_geog_icb, )

bgts_cgm_geog_icb |> group_by(year_month2, region) |> summarise(items = sum(items)) |> 
  filter(year_month2 <= "Jul 2022") |> 
  filter(region != "Unidentified Doctors") |> 
  pivot_wider(names_from = region, values_from = items) |>
  dygraph()
