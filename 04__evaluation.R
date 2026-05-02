# --------------------------------------------------
# 04_evaluation.R
# Project: Cardiovascular Risk Prediction (BRFSS)
# Purpose: Evaluate final model on test data
# --------------------------------------------------

# 1. Load data
# 2. Predictions
# 3. Evaluation
# 4. Interpretation

# Libraries
library(caret)
library(dplyr)

# 1. Load data
brfss <- read.csv("brfss_clean.csv")
brfss$cvd <- factor(brfss$cvd)

set.seed(150)
train_index <- createDataPartition(brfss$cvd, p = 0.8, list = FALSE)
test <- brfss[-train_index, ]

# Load models
model_glm <- readRDS("model_glm.rds")
model_rf  <- readRDS("model_rf.rds")
model_ranger  <- readRDS("model_ranger.rds")

# 3. Predictions
prob_glm <- predict(model_glm, test, type = "prob")[, "Yes"]
prob_rf  <- predict(model_rf,  test, type = "prob")[, "Yes"]
prob_ranger <- predict(model_ranger, test, type = "prob")[, "Yes"]

threshold <- 0.5

pred_glm <- factor(ifelse(prob_glm > threshold, "Yes", "No"), levels = c("Yes", "No"))
pred_rf  <- factor(ifelse(prob_rf  > threshold, "Yes", "No"), levels = c("Yes", "No"))
pred_ranger <- factor(ifelse(prob_ranger > threshold, "Yes", "No"), levels = c("Yes", "No"))

# 4. Evaluation
#Confusion matrix
conf_glm <- confusionMatrix(pred_glm, test$cvd, positive = "Yes")
conf_rf  <- confusionMatrix(pred_rf,  test$cvd, positive = "Yes")
conf_ranger <- confusionMatrix(pred_ranger, test$cvd, positive = "Yes")

conf_glm
conf_rf
conf_ranger

# 5. Metrics
model_performance <- data.frame(
  Model       = c("Logistic", "RandomForest", "ranger"),
  ROC         = c(max(model_glm$results$ROC), max(model_rf$results$ROC), max(model_ranger$results$ROC)),
  Sensitivity = c(conf_glm$byClass["Sensitivity"], conf_rf$byClass["Sensitivity"], conf_ranger$byClass["Sensitivity"]),
  Specificity = c(conf_glm$byClass["Specificity"], conf_rf$byClass["Specificity"], conf_ranger$byClass["Specificity"]),
  Accuracy    = c(conf_glm$overall["Accuracy"],    conf_rf$overall["Accuracy"], conf_ranger$overall["Accuracy"])
)

model_performance

# Exporting results
capture.output(conf_glm, file = "confusion_matrix_glm.txt")
capture.output(conf_rf,  file = "confusion_matrix_rf.txt")
capture.output(conf_ranger,  file = "confusion_matrix_ranger.txt")

write.csv(
  model_performance,
  "model_comparison.csv",
  row.names = FALSE
)

# 5. Interpretation
# Random Forest: Weakest overall, despite its high specificity (0.82) 
# its sensitivity is only 0.42, which means it misses 58% of sick patients.
# this lack in sensitivity is more relevant than its high specificity in a 
# patology predicting model. This model is not suitted for this problem.

# Logistic Regression: Strong choice with decent specificity (0.72) and 
# the highest sensitivity among the three (0.76)

# Ranger: Strong choice due to its balance between sensitivity (0.74) and 
# specificity (0.74)

# In conclusion, results show that Logistic Regression achieved the highest ROC-AUC
# (0.82) confirming its strong overall discriminating ability. However, Ranger demonstrated
# the most clinically balance performance, achieving nearly equal sensitivity and specificity
# making it the most reliable model for real-world cardiovascular risk screening where
# both false negative and false positives carry meaningful consequences

# With a ROC-AUC of 0.82, the Logistic Regression model has genuine discriminative power 
# that could meaningfully separate high-risk from low-risk individuals at a population 
# level. Used as a screening and prioritization tool within a public health framework, 
# this model could have real practical value in early cardiovascular risk detection programs.
# instead of using the 0.5 threshold to classify patients, non-diagnosed individuals
# could be ranked by their predicted probability and prioritize the highest risk ones
# for further clinical evaluation.