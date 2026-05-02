# --------------------------------------------------
# 01_load_and_clean.R
# Project: Cardiovascular Risk Prediction (BRFSS)
# Purpose: Load and clean raw BRFSS data
# --------------------------------------------------
# 1. Data Load
# 2. Select relevant variables
# 3. Data cleaning and target engineering
# 4. Final Dataset

# Libraries
library(haven)      
library(tidyverse)  
library(janitor)    
library(caret)

# 1. Data Load
file_path <- "LLCP2024.XPT"

brfss_raw <- read_xpt(file_path)

glimpse(brfss_raw)
dim(brfss_raw)

# 2. Select relevant variables for cardiovascular risk modeling
brfss <- brfss_raw %>%
  select(
    CHDorMI = `_MICHD`,
    stroke = CVDSTRK3,
    age = `_AGEG5YR`,
    sex = `_SEX`,
    income = `_INCOMG1`,
    healthauto = GENHLTH,
    BMI = `_BMI5CAT`,
    diabetes = DIABETE4,
    asthma = `_LTASTH1`,
    cancer = CHCOCNC1,
    kidney_disease = CHCKDNY2,
    smoker = `_SMOKER3`,
    alcohol = DRNKANY6,
    phys_activity = `_TOTINDA`
  )


#Inspect raw target distributions (useful for class imbalance analysis)
table(brfss$stroke, useNA = "ifany")
table(brfss$CHDorMI, useNA = "ifany")

#3. Data cleaning and taget engineering

#Define missing value codes
na_codes <- list(
  age = c(14),
  income = c(9),
  healthauto = c(7, 9),
  diabetes = c(7, 9),
  asthma = c(9),
  cancer = c(7, 9),
  kidney_disease = c(7, 9),
  smoker = c(9),
  alcohol = c(7, 9),
  phys_activity = c(9)
)

brfss_clean <- brfss %>%
  # Replace invalid codes in stroke before target creation
  mutate(
    stroke = na_if(stroke, 7),
    stroke = na_if(stroke, 9)
  ) %>%
  # Create binary target: cardiovascular disease (CVD)
  mutate(
    cvd = case_when(
      CHDorMI == 1 | stroke == 1 ~ 1L,
      CHDorMI == 2 & stroke == 2 ~ 0L,
      TRUE ~ NA_integer_ # ambiguous or missing cases removed later
    )
  ) %>%
  # Apply dataset-specific NA recoding
  mutate(
    across(
      all_of(names(na_codes)),
      ~ ifelse(. %in% na_codes[[cur_column()]], NA, .)
    )
  )%>%
  # Remove rows with undefined target
  filter(!is.na(cvd))

brfss_clean <- brfss_clean %>%
  select(-CHDorMI, -stroke)

# Treating NA as explicit "Unknown" category for variables that 
# capture relevant information in NA variable
brfss_clean <- brfss_clean %>%
  mutate(
    income  = ifelse(is.na(income),  "Unknown", as.character(income)),
    alcohol = ifelse(is.na(alcohol), "Unknown", as.character(alcohol)),
    smoker  = ifelse(is.na(smoker),  "Unknown", as.character(smoker)),
    BMI     = ifelse(is.na(BMI),     "Unknown", as.character(BMI))
  )

# Imputing NAs for variables that do not capture relevant 
# information in NA variable
pre_impute <- preProcess(brfss_clean, method = "medianImpute")
brfss_clean <- predict(pre_impute, brfss_clean)

  # Convert to factors
brfss_clean <- brfss_clean %>%
  mutate(
    cvd = factor(cvd, levels = c(0, 1), labels = c("No", "Yes")),
    age = factor(age),
    sex = factor(sex),
    income = factor(income),
    healthauto = factor(healthauto),
    BMI = factor(BMI),
    diabetes = factor(diabetes),
    asthma = factor(asthma),
    cancer = factor(cancer),
    kidney_disease = factor(kidney_disease),
    smoker = factor(smoker),
    alcohol = factor(alcohol),
    phys_activity = factor(phys_activity),
  )

# 4. Final dataset
output_path <- "brfss_clean.csv"

write.csv(
  brfss_clean,
  output_path,
  row.names = FALSE
)

#write_xpt(
#  brfss_clean,
#  output_path
#)

# Check class balance (important for model selection & metrics)
glimpse(brfss_clean)
summary(brfss_clean$cvd)



