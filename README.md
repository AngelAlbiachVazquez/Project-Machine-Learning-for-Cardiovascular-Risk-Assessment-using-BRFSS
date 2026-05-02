# Project-Machine-Learning-for-Cardiovascular-Risk-Assessment-using-BRFSS
Machine learning models for cardiovascular disease risk stratification using the 2024 CDC BRFSS survey (450k+ observations). Compares Logistic Regression, Random Forest and Ranger with class imbalance correction for population-level risk screening pruposes. The model aims to help identify individuals at highestcardiovascular risk for further clinical evaluation. Built in R with caret.

CVD is the leading cause of death globally, responsible for approximately 1 in 3 deaths worldwide according to WHO. CVD carries enormous burden beyond mortality: heart failure, stroke sequelae, reduced quality of life and high healthcare costs. That, paired with the difficulty of early detection due to its asymptomatic profile in its early stages makes early risk identification a critical public heath priority

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
├──       ← place LLCP2024.XPT here</br>
├──       ← brfss_clean.csv generated here</br>
├── 01_load_and_clean.R       ← data loading, cleaning and preprocessing</br>
├── 02_eda.R                  ← exploratory Data Analysis</br>
├── 03_model_training.R       ← model training and cross-validation</br>
├── 04_evaluation.R           ← model evaluation and comparison</br>
│</br>
├─ results/</br>
│    ├── model_comparison.csv</br>
│    ├── confusion_matrix_glm.txt</br>
│    ├── confusion_matrix_rf.txt</br>
│    └── confusion_matrix_ranger.txt</br>
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

## Variables Used
| Variable | Description |
|---|---|
| `age` | Age group (5-year intervals) |
| `sex` | Biological sex |
| `income` | Income level |
| `healthauto` | Self-reported general health |
| `BMI` | Body Mass Index category |
| `diabetes` | Diabetes diagnosis |
| `asthma` | Asthma diagnosis |
| `cancer` | Cancer diagnosis |
| `kidney_disease` | Kidney disease diagnosis |
| `smoker` | Smoking status |
| `alcohol` | Alcohol consumption |
| `phys_activity` | Physical activity level |

**Target variable:** `cvd` — Combined indicator of coronary heart disease
or stroke (1 = CVD, 0 = No CVD)

## Results Summary
Three models were trained and evaluated using 5-fold cross-validation
with class weights to address class imbalance (~7:1 ratio):

| Model | ROC-AUC | Sensitivity | Specificity | Accuracy |
|---|---|---|---|---|
| Logistic Regression | 0.820 | 76% | 72% | 73% |
| Random Forest | 0.729 | 42% | 83% | 78% |
| Ranger | 0.814 | 74% | 74% | 74% |

**Ranger** achieved the most clinically balanced performance with equal
Sensitivity and Specificity (~74%), making it the recommended model for
cardiovascular risk screening applications.

**Logistic Regression** achieved the highest ROC-AUC (0.820) and is
recommended when maximizing sick patient detection is the priority.

## Clinical Relevance
This model is intended as a **population-level risk screening tool**,
not a diagnostic instrument. By ranking individuals by their predicted
CVD probability, it can help public health systems prioritize limited
medical resources toward the highest-risk populations using only
self-reported survey data, with no clinical tests required.

## Author
Àngel — Data Science Project, 2025
