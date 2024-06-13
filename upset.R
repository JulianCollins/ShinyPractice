# upsetjs

library(upsetjs)

listInput <- list(one = c(1, 2, 3, 5, 7, 8, 11, 12, 13), two = c(1, 2, 4, 5, 10), three = c(1, 5, 6, 7, 8, 9, 10, 12, 13))


upsetjs() %>% fromList(listInput) %>% interactiveChart()


listInput <- list(A = c("a", "b"), B = c(sample(letters, 10)), three = c(sample(letters, 10)))


upsetjs() %>% fromList(listInput) %>% interactiveChart()


