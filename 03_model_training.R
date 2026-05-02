# --------------------------------------------------
# 03_model_training.R
# Project: Cardiovascular Risk Prediction (BRFSS)
# Purpose: Train and compare ML models
# --------------------------------------------------

# 1. Load data
# 2. Partición train / test
# 3. Training control
# 4. Model training
# 5. Model comparison
# 6. Save models and results

# Libraries
library(caret)
library(dplyr)
library(randomForest)
library(ranger)

# 1. Load data
brfss <- read.csv(
  "brfss_clean.csv",
  stringsAsFactors = FALSE
)

brfss$cvd <- factor(brfss$cvd)

# Spliting dataset to reduce computational cost,
# for the full correct model the dataset should not
# be splitted
set.seed(150)
idx <- createDataPartition(brfss$cvd, p = 0.2, list = FALSE)
brfss_sample <- brfss[idx, ]

# 2. Train / Test split
set.seed(150)
train_index <- createDataPartition(
  brfss_sample$cvd,
  p = 0.8,
  list = FALSE
)

train <- brfss_sample[train_index, ]
test  <- brfss_sample[-train_index, ]

# 3. Training control
control <- trainControl(
  method = "cv",
  number = 5, # 10 folds for better results but more computational cost
  classProbs = TRUE,
  summaryFunction = twoClassSummary
)

# 4. Model training
# Logistic Regression
set.seed(150)
model_glm <- train(
  cvd ~ .,
  data = train,
  method = "glm",
  family = binomial,
  metric = "ROC", # ROC more robust to imbalance than accuracy
  trControl = control,
  weights = ifelse(train$cvd == "Yes", 7, 1) #Class imbalance handling 
)

# knn
# set.seed(150)
# model_knn <- train(
#   cvd ~ .,
#   data = train,
#   method = "knn",
#   metric = "ROC",
#   trControl = control,
#   preProcess = c("center", "scale")
# )
# knn not suitable for this problem due to high imbalance in target variable

# Random Forest
set.seed(150)
model_rf <- train(
  cvd ~ .,
  data = train,
  method = "rf",
  metric = "ROC",
  trControl = control,
  classwt = c("No" = 1, "Yes" = 7) #Class imbalance handling 
)

# Ranger (faster RF implementation)
set.seed(150)
model_ranger <- train(
  cvd ~ .,
  data = train,
  method = "ranger",
  metric = "ROC",
  trControl = control,
  weights = ifelse(train$cvd == "Yes", 7, 1) #Class imbalance handling 
)

# 5. Model comparison
results <- resamples(
  list(
    Logistic = model_glm,
    RandomForest = model_rf,
    ranger = model_ranger
  )
)

summary(results)

model_performance <- data.frame(
  Model = c("Logistic", "RandomForest", "ranger"),
  ROC = c(
    max(model_glm$results$ROC),
    max(model_rf$results$ROC),
    max(model_ranger$results$ROC)
  )
)
model_performance

# 6. Save models and results

saveRDS(model_glm, "model_glm.rds")
saveRDS(model_rf, "model_rf.rds")
saveRDS(model_ranger, "model_ranger.rds")

write.csv(
  model_performance,
  "model_comparison.csv",
  row.names = FALSE
)


