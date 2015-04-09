library(data.table)

# Kad viskas veiktų kiek greičiau
library(doMC) 
registerDoMC()

# Pirmiem testams galime naudotis caret, modelių sąrašas: http://topepo.github.io/caret/bytag.html
library(caret)

# Duomenų skaitymas
train <- fread("train.csv")
test <- fread("test.csv")

# Kai kuriems modeliams bus naudingi faktoriai, tačiau galima užkomentuoti
train[, target := as.factor(target)]

# Eilučių kiekis
n <- nrow(train)

# Visur stengiamės naudoti seed, kad galėtume atkartoti rezultatus
set.seed(42)

# sukuriame indeksus lokaliai train aibei
m <- round(n*0.75)
index <- sample(n, size = m)

# formuojame aibes (reikia pergalvoti pavadinimus)
local_train = train[index,]
local_test = train[-index,]

#################################################
#              Modeliavimo dalis                #
#################################################

# testui naudosimės random forest

# caret reikia atskirtų target ir features, taigi atskiriame:
target <- local_train[, target]
features <- local_train[, 2:94, with = FALSE] # išmetame id

model <- train(features, target, method = "rf")

prediction <- predict(model, local_test)

#################################################
#            Paklaidos vertinimas               #
#################################################

# Funkcija paimta iš Kaggle: https://www.kaggle.com/wiki/LogarithmicLoss
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

# Konvertuojame į matricinius pavidalus
# Svarbu, čia model.matrix yra funkcija, ji nesusijusi su model! ;)
prediction_matrix <- model.matrix(~ 0+prediction)
actual_matrix <- model.matrix(~ 0+local_test[,target])

MultiLogLoss(prediction_matrix, actual_matrix)

#################################################
#            Rezultatų pateikimas               #
#################################################

# Pritaikome modelį test rezultatams
results <- predict(model, test)

# Paverčiame matriciniu pavidalu ir sutvarkome
results <- data.table(model.matrix(~ 0 + results))
setnames(results, c("Class_1", "Class_2", "Class_3", "Class_4", "Class_5", "Class_6", "Class_7", "Class_8", "Class_9"))
results[, id := 1:dim(test)[1]]
setcolorder(results, c("id", "Class_1", "Class_2", "Class_3", "Class_4", "Class_5", "Class_6", "Class_7", "Class_8", "Class_9"))

# Surašome resultatus į failą
write.table(results, file = "submission.csv", sep = ",", quote = FALSE, row.names = FALSE)

