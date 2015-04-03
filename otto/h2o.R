library(data.table)
library(h2o)
localH2O = h2o.init()

DT <- fread("train.csv")
DT[, target := as.factor(target)]

n <- nrow(DT)
set.seed(42)
index <- sample(n)
DT = DT[index,]
DT.hex <- as.h2o(localH2O, DT)

deep <- h2o.deeplearning(x=2:94, y=95, data = DT.hex, classification = TRUE, nfolds = 10, override_with_best_model = TRUE)

#logloss estimation
prediction <- h2o.predict(deep, DT.hex)
results <- data.table(as.data.frame(prediction))
results[,predict := NULL]
real_labels <- data.table(cbind(model.matrix(~ 0 + target, DT)))
eps = 1e-15;
-sum(log(results+eps)*real_labels)/n
# deeplearning benchmark: local 0.386647, kaggle 0.57369

# path <- h2o.saveModel(object = deep)
# h2o.loadModel(localH2O, path)

test <- fread("test.csv")
index <- test[, id]
test.hex <- as.h2o(localH2O, test)
prediction <- h2o.predict(deep, test.hex)
results <- data.table(as.data.frame(prediction))

results[, predict := index]

colnames(results)[which(colnames(results) == "predict")] = "id"

setkey(results, id)
results
write.table(results, file = "deep_benchmark.csv", sep = ",", quote = FALSE, row.names = FALSE)

# logloss <- -1/n sum(sum())
# Paprasčiau bus su matricomis

#Class_1 Class_2 Class_3 Class_4 Class_5 Class_6 Class_7 Class_8 Class_9 
#   1929   16122    8004    2691    2739   14135    2839    8464    4955 