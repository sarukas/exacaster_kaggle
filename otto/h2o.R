library(data.table)
library(h2o)
localH2O = h2o.init()

# Logloss estimation iš kaggle
MultiLogLoss <- function(act, pred)
{
  eps = 1e-15;
  nr <- nrow(pred)
  pred = matrix(sapply( pred, function(x) max(eps,x)), nrow = nr)      
  pred = matrix(sapply( pred, function(x) min(1-eps,x)), nrow = nr)
  ll = sum(act*log(pred) )
  ll = ll * -1/(nrow(act))      
  return(ll);
}

# Skaitome duomenis
train <- fread("train.csv")
test <- fread("test.csv")
train[, target := as.factor(target)]
n <- nrow(train)

# Sukuriame training set, šiuo atveju tiesiog sumaišiau eilutes
# Reikia padaryti split taip kaip template.R
set.seed(42)
m <- round(n*0.75)
index <- sample(n, size = m)

local_train = train[index,]
local_test = train[-index,]
local_train.hex <- as.h2o(localH2O, local_train)
local_test.hex <- as.h2o(localH2O, local_test)

################################
#     Modelling part           #
################################

model <- h2o.deeplearning(x=2:94, y=95, data = local_train.hex, classification = TRUE, nfolds = 10, override_with_best_model = TRUE, seed = 42)
model <- h2o.gbm(x=2:94, y=95, data = local_train.hex, nfolds = 10, n.trees = 20)
model <- h2o.SpeeDRF(x=2:94, y=95, data = local_train.hex, nfolds = 10, classification = TRUE, seed = 42)
model <- h2o.randomForest(x=2:94, y=95, data = local_train.hex, depth = 25, nfolds = 10, classification = TRUE, seed = 42)

################################
#         Rezultatai           #
################################

# local_train rezultatai
prediction <- h2o.predict(model, local_train.hex)
results <- data.table(as.data.frame(prediction))
results[, predict := NULL]
results_matrix <- as.matrix(results)
actual_matrix <- model.matrix(~ 0 + target, local_train)
MultiLogLoss(actual_matrix, results_matrix)

# local_test rezultatai
prediction <- h2o.predict(model, local_test.hex)
results <- data.table(as.data.frame(prediction))
results[, predict := NULL]
results_matrix <- as.matrix(results)
actual_matrix <- model.matrix(~ 0 + target, local_test)
MultiLogLoss(actual_matrix, results_matrix)


#                               local_train score   local_test score    kaggle score
# h2o.deeplearning benchmark    0.4062493           0.6180687           0.57369
# h2o.gbm benchmark             0.7232466           0.7653265
# h2o.SpeeDRF benchmark         0.4176488           0.9722669
# h2o.randomForest benchmark    0.22919             0.769467


# Prireikus galima išsaugoti modelį ir jį atkurti
# path <- h2o.saveModel(object = deep)
# h2o.loadModel(localH2O, path)

# Pritaikome modelį test.csv
index <- test[, id]
test.hex <- as.h2o(localH2O, test)
prediction <- h2o.predict(deep, test.hex)
results <- data.table(as.data.frame(prediction))

# Kadangi pasimeta index ir atsiranda predict, tai greitai sutvarkome
results[, predict := index]
setnames(results, "predict", "id")

#Surašome viską į failą
write.table(results, file = "deep_benchmark.csv", sep = ",", quote = FALSE, row.names = FALSE)



# Duomenų pasiskirstymas pagal klases:
#Class_1 Class_2 Class_3 Class_4 Class_5 Class_6 Class_7 Class_8 Class_9 
#   1929   16122    8004    2691    2739   14135    2839    8464    4955 