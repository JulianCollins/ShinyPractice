# shotfield medical practice prescribing data for Feb 24


# setup -----------------------------

library(plotly)
library(janitor)
library(tidyverse)
library(rio)


shotfield <- read_csv("udal_month_shotfield.csv") |> clean_names()

glimpse(shotfield)

# save top 100 rows as aide memoire for udal work

shotfield |> 
  slice_head(n = 100) |> 
  export("udal_meds_fields.xlsx") 


# slim to required fields

shotfield <- shotfield |> 
  select(der_pseudo_nhs_number, starts_with("patient"), age_bands,
         dispensed_pharmacy_ods_code, dispensed_pharmacy_type,
         item_actual_cost, item_nic, item_count,
         prescribed_bnf_code, prescribed_bnf_name, prescribed_medicine_strength, prescribed_quantity, prescribeddmd_code,
         paid_acbs_indicator, paiddmd_code, paid_supplier_name,
         processing_period_date) |> 
  distinct()

# field types

shotfield <- shotfield |> 
  mutate(across(c(patient_gpccg, patient_gender, dispensed_pharmacy_type, prescribeddmd_code, paiddmd_code), as.character))

glimpse(shotfield)  


shotfield |> 
  group_by(prescribed_bnf_name) |> 
  summarise(N = n_distinct(der_pseudo_nhs_number)) |> 
  arrange(desc(N)) |> View()


# add bnf details ---------------------------------------------------------------

# pca file

bnf <- import("pca_summary_tables_2022_23_v001.xlsx", sheet = "Presentations", skip = 3) |> clean_names()

glimpse(bnf)


bnf_classification <- bnf |> 
  select(starts_with(c("bnf", "generic"))) |> 
  distinct()


# join to data

shotfield <- shotfield |> 
  left_join(select(bnf_classification, bnf_presentation_code, bnf_chemical_substance_name, bnf_paragraph_name, bnf_section_name, bnf_chapter_name),
            by = c("prescribed_bnf_code" = "bnf_presentation_code")) |> 
  distinct()

# analyse -----------------------

shotfield |> 
  select(der_pseudo_nhs_number, prescribed_bnf_name) |> 
 # group_by(der_pseudo_nhs_number) |> 
  pivot_wider(names_from = prescribed_bnf_name)
