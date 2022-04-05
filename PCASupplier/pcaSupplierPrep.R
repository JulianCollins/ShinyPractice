## PCA data for Shiny app

library(rio)
library(skimr)
library(bit64)
library(plotly)
library(dygraphs)
library(tidyverse)


PCA_2021 <- import("~/OneDrive - NHS England/Primary Care/PCA/Latest Annual Tables/pca_stp_snomed_2020_2021.csv")
PCA_1920 <- import("~/OneDrive - NHS England/Primary Care/PCA/Latest Annual Tables/pca_stp_snomed_2019_2020.csv")
PCA_1819 <- import("~/OneDrive - NHS England/Primary Care/PCA/Latest Annual Tables/pca_stp_snomed_2018_2019.csv")

PCA_STP_SNOMED_SUPPLIER <- bind_rows(PCA_1819, PCA_1920, PCA_2021) %>% as_tibble()

skim(PCA_STP_SNOMED_SUPPLIER)

PCA_STP_SNOMED_SUPPLIER$SNOMED_CODE <- as.character.integer64(PCA_STP_SNOMED_SUPPLIER$SNOMED_CODE)


pcaSTPSnomedSupplierTrimmed <- PCA_STP_SNOMED_SUPPLIER %>% select(-ends_with("_CODE"), -ends_with("CLASS"), -UNIT_OF_MEASURE, -REGION_NAME, -STP_NAME)

top20 <- pcaSTPSnomedSupplierTrimmed %>% filter(YEAR_DESC == "2020/2021", SUPPLIER_NAME != "") %>% group_by(SUPPLIER_NAME) %>% summarise(totNIC = sum(NIC, na.rm = T)) %>% slice_max(order_by = totNIC, n = 20)

pcaSTPSnomedSupplierTrimmedTop20 <- pcaSTPSnomedSupplierTrimmed %>% filter(SUPPLIER_NAME %in% top20$SUPPLIER_NAME)

pcaSTPSnomedSupplierTrimmedTop20 <- pcaSTPSnomedSupplierTrimmed %>% filter(SUPPLIER_NAME %in% top20$SUPPLIER_NAME) %>% group_by(SUPPLIER_NAME, YEAR_DESC, BNF_CHAPTER) %>% 
                                    mutate(chapTotNIC = sum(NIC, na.rm = T)) %>% ungroup()

saveRDS(pcaSTPSnomedSupplierTrimmedTop20, "pcaSTPSnomedSupplierTrimmedTop20.Rds")


pcaSTPSnomedSupplierTrimmed <- pcaSTPSnomedSupplierTrimmed %>% group_by(SUPPLIER_NAME, YEAR_DESC, BNF_CHAPTER) %>% 
  mutate(chapTotNIC = sum(NIC, na.rm = T)) %>% ungroup()

saveRDS(pcaSTPSnomedSupplierTrimmed, "pcaSTPSnomedSupplierTrimmed.Rds")

