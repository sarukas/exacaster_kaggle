library(data.table)
library(h2o)
localH2O = h2o.init()

# Skaitome duomenis
DT <- fread("train.csv")
DT[, target := as.factor(target)]
n <- nrow(DT)

# Sukuriame training set, šiuo atveju tiesiog sumaišiau eilutes
# Reikia padaryti split taip kaip template.R
set.seed(42)
index <- sample(n)
DT = DT[index,]
DT.hex <- as.h2o(localH2O, DT)

# Neural network modelis
deep <- h2o.deeplearning(x=2:94, y=95, data = DT.hex, classification = TRUE, nfolds = 10, override_with_best_model = TRUE)

# Logloss estimation 
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

prediction <- h2o.predict(deep, DT.hex)
results <- data.table(as.data.frame(prediction))
results[, predict := NULL]
#real_labels <- data.table(cbind(model.matrix(~ 0 + target, DT)))

actual_matrix <- model.matrix(~ 0 + target, DT)

MultiLogLoss(actual_matrix, as.matrix(results))
# deeplearning benchmark: local score 0.38897, kaggle score 0.57369

# Prireikus galima išsaugoti modelį ir jį atkurti
# path <- h2o.saveModel(object = deep)
# h2o.loadModel(localH2O, path)

# Pritaikome modelį test.csv
test <- fread("test.csv")
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