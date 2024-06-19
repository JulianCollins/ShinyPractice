# Data prep for upset walkthrough

library(tidyverse)
library(rio)

glimpse(PHEDataLatest1920)

names(PHEDataLatest1920)

upsetData <- PHEDataLatest1920 %>% select(pid, agegp, genderidentity, artLength, dplyr::ends_with("Name"), -sitename, -ODS_Name)


upsetData <- upsetData %>% mutate(pid = paste0("1", str_pad(seq_along(pid), 6, pad = "0")))

# replace with random drugs
BNFNames <- BNF_SNOMED %>% filter(!is.na(`BNF Name`), `BNF Name` != "") %>% select(`BNF Name`) %>% na.omit()

drugRandom <- sample(BNFNames$`BNF Name`, 54)

drugRandom <- bind_cols(drugRandom, artTreatments) %>% rename(Random = ...1, Real = ...2)

upsetData <- upsetData %>% left_join(drugRandom, by = c("artdrug1Name" = "Real"))
upsetData <- upsetData %>% left_join(drugRandom, by = c("artdrug2Name" = "Real"))
upsetData <- upsetData %>% left_join(drugRandom, by = c("artdrug3Name" = "Real"))
upsetData <- upsetData %>% left_join(drugRandom, by = c("artdrug4Name" = "Real"))
upsetData <- upsetData %>% left_join(drugRandom, by = c("artdrug5Name" = "Real"))
upsetData <- upsetData %>% left_join(drugRandom, by = c("artdrug6Name" = "Real"))

upsetData <- upsetData %>% rename(dummyDrug1 = Random.x, dummyDrug2 = Random.y, dummyDrug3 = Random.x.x, dummyDrug4 = Random.y.y, dummyDrug5 = Random.x.x.x, dummyDrug6 = Random.y.y.y)

upsetData <- upsetData %>% select(-starts_with("artdrug"))

upsetData <- upsetData %>% rename(treatLength = artLength)

export(upsetData, "upsetData.csv")


