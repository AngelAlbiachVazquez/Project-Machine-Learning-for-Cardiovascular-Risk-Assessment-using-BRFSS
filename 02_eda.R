# --------------------------------------------------
# 02_eda.R
# Project: Cardiovascular Risk Prediction (BRFSS)
# Purpose: Exploratory Data Analysis
# --------------------------------------------------

# 1. Load and clean dataset
# 2. General overview
# 3. Univariate analysis
# 4. Bivariate Analysis
# 5. Visualization of Key Relationships
# 6. EDA Conclusions

# Libraries
library(dplyr)
library(ggplot2)

# 1. Load clean dataset
brfss_clean <- read.csv(
  "brfss_clean.csv",
  stringsAsFactors = FALSE
)

# 2. General overview
summary(brfss_clean)

# 3. Univariate Analysis
eda_univariate <- function(data, var) {
  data %>%
    count({{ var }}) %>% #conteo 
    mutate(prop = n / sum(n)) #proporción relativa
}

eda_univariate(brfss_clean, sex)
eda_univariate(brfss_clean, income)
eda_univariate(brfss_clean, BMI)
eda_univariate(brfss_clean, healthauto)
eda_univariate(brfss_clean, age)
eda_univariate(brfss_clean, diabetes)
eda_univariate(brfss_clean, asthma)
eda_univariate(brfss_clean, cancer)
eda_univariate(brfss_clean, kidney_disease)
eda_univariate(brfss_clean, smoker)
eda_univariate(brfss_clean, alcohol)
eda_univariate(brfss_clean, phys_activity)
#Observamos que nuestras variables parecen estar adecuadamente distribuidas
#Adicionalmente en ninguna tenemos una aparición de respuestas inválidas superior al 20%

# 4. Bivariate Analysis (vs CVD)
eda_bivariate <- function(data, var) {
  data %>%
    count({{ var }}, cvd) %>%
    group_by({{ var }}) %>%
    mutate(prop = n / sum(n))
}

# Apply to all predictors
eda_bivariate(brfss_clean, sex)
eda_bivariate(brfss_clean, income)
eda_bivariate(brfss_clean, BMI)
eda_bivariate(brfss_clean, healthauto)
eda_bivariate(brfss_clean, age)
eda_bivariate(brfss_clean, diabetes)
eda_bivariate(brfss_clean, asthma)
eda_bivariate(brfss_clean, cancer)
eda_bivariate(brfss_clean, kidney_disease)
eda_bivariate(brfss_clean, smoker)
eda_bivariate(brfss_clean, alcohol)
eda_bivariate(brfss_clean, phys_activity)

# 5. Visualization of Key Relationships
# Diabetes vs CVD
ggplot(brfss_clean,
  aes(
    x = factor(
      diabetes,
      levels = c(1, 2, 3, 4),
      labels = c("Diabetes","Gestational","No diabetes","Prediabetes")
      ),
    fill = cvd
    )) +
  geom_bar(position = "fill") +
  labs(
    x = "Diabetes state", #Title x axis
    y = "Proportion", #Title y axis
    fill = "CVD", #Title legend
    title = "CVD proportion by diabetes status" #Title graph
  )
# Insight:
# Higher prevalence of CVD among diabetic and prediabetic individuals

# Smoking vs CVD
ggplot(brfss_clean,
       aes(
         x = factor(
           smoker,
           levels = c(1, 2, 3, 4),
           labels = c("Daily", "Usually", "Former", "Never")
           ),
         fill = cvd
       )) +
  geom_bar(position = "fill") + 
  labs(
    x = "Smoking frecuency",
    y = "Proportion",
    fill = "CVD",
    title = "CVD proportion according to smoking frecuency"
  )
# Insight:
# Daily smokers show higher CVD prevalence

#Kidney disease vs CVD
ggplot(brfss_clean,
       aes(
         x = factor(
           kidney_disease,
           levels = c(1,2),
           labels = c("kidney dissease", "no kidney dissease")
         ),
         fill = cvd
       )) +
  geom_bar(position = "fill") + 
  labs(
    x = "kidney_disease",
    y = "Proportion",
    fill = "CVD",
    title = "CVD proportion according to kidney_disease"
  )
#A higher number of comorbidities substantially impacts the chance of suffering a CVD

# 6. EDA Conclusions
# Key findings:
# - No severe sparsity detected in categorical variables (>20% invalid values rule satisfied)
# - Evidence of clinical and behavioral risk patterns

# Important ML considerations:
# - Potential class imbalance in target variable (must be handled during modeling)

