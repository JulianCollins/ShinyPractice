library(tidyverse)
library(plotly)

diamonds |>
  ggplot(aes(price, color, fill = cut)) +
  geom_boxplot(alpha = 0.7) +
  theme_minimal() +
  scale_fill_viridis_d(option = 'G')

diamonds |>
  plot_ly(x = ~price, y = ~color, color = ~cut, type = 'box') |>
  layout(boxmode = 'group')

glimpse(diamonds)

datasets::airquality
datasets::EuStockMarkets

glimpse(EuStockMarkets)

dygraphs::dygraph(EuStockMarkets)
