# Project-Machine-Learning-for-Cardiovascular-Risk-Assessment-using-BRFSS
Machine learning models for cardiovascular disease risk stratification using the 2024 CDC BRFSS survey (450k+ observations). Compares Logistic Regression, Random Forest and Ranger with class imbalance correction for population-level risk screening pruposes. The model aims to help identify individuals at highestcardiovascular risk for further clinical evaluation. Built in R with caret.

## Dataset
The data comes from the **2024 BRFSS survey**, conducted by the CDC.
It contains over 450,000 observations and covers behavioral, demographic,
and health-related variables across the United States.

### How to download the data
1. Go to: https://www.cdc.gov/brfss/annual_data/annual_2024.html
2. Download the SAS Transport Format file: `LLCP2024.XPT`
3. Place it in the main folder

## Project Structure
Project_CardiovascularRisk/ </br>
│</br>
├──       ← place LLCP2024.XPT here</br>
├──       ← brfss_clean.csv generated here</br>
│ </br>
├── 01_load_and_clean.R       ← data loading, cleaning and preprocessing</br>
├── 02_eda.R                  ← exploratory Data Analysis</br>
├── 03_model_training.R       ← model training and cross-validation</br>
├── 04_evaluation.R           ← model evaluation and comparison</br>
│</br>
├── results/</br>
│   ├── model_comparison.csv</br>
│   ├── confusion_matrix_glm.txt</br>
│   ├── confusion_matrix_rf.txt</br>
│   └── confusion_matrix_ranger.txt</br>
│</br>
└── README.md

## How to Run
Run the scripts in the following order:

**Step 1 — Data preprocessing:**
```r
source("01_load_and_clean.R")
```
**Step 2 — Exploratory data analysis:** (Not mandatory for step 3)
```r
source("02_eda.R")
```

**Step 3 — Model training:**
```r
source("03_model_training.R")
```

**Step 4 — Evaluation:**
```r
source("04_evaluation.R")
```

## Required R Packages
Install all required packages by running:
```r
install.packages(c(
  "haven",
  "tidyverse",
  "janitor",
  "caret",
  "randomForest",
  "ranger",
  "dplyr"
))
```

## Author
Àngel — Data Science Project, 2025
