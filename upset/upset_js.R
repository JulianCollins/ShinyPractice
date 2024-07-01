# upsetjs

library(upsetjs)
library(RColorBrewer)
library(tidyverse)

listInput <- list(one = c(1, 2, 3, 5, 7, 8, 11, 12, 13), two = c(1, 2, 4, 5, 10), three = c(1, 5, 6, 7, 8, 9, 10, 12, 13))

colours <- list(two = "red", one = "green", three = "blue")

colours2 <- list(scale_color_viridis_d())

upsetjs() %>% fromList(listInput, colors = colours) %>% 
  chartTheme(selection.color = "", has.selection.opacity = 0.5) |> 
  interactiveChart()

upsetjs() %>% 
  fromList(listInput) %>%
  #chartTheme(selection.color = "", has.selection.opacity = 0.5) |> 
  generateDistinctIntersections(min = 1)

listInput <- list(A = c("a", "b"), B = c(sample(letters, 10)), three = c(sample(letters, 10)))


upsetjs() %>% fromList(listInput) %>% interactiveChart()


