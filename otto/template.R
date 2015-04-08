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

# testui naudosimės rpart: Recursive Partitioning and Regression Trees

# caret reikia atskirtų target ir features, taigi atskiriame:
target <- local_train[, target]
features <- local_train[, 2:94, with = FALSE] # išmetame id

model <- train(features, target, method = "rpart")

prediction <- predict(model, local_test)

#################################################
#            Paklaidos vertinimas               #
#################################################

# Reikia įsitikinti, kad veikia taip kaip reikia!
LogLoss <- function(act, pred) {
  -sum(act*log(pred))/(n - m)
}

# Blogai, reikia konvertuoti į matricinį pavidalą!
LogLoss(as.numeric(local_test[, target]), as.numeric(prediction))

#################################################
#            Rezultatų pateikimas               #
#################################################

# Class 1 missing
index <- test[, id]
results <- data.table(id = index, predict = predict(model, test))
results <- data.table(model.matrix(~ id + predict, results))
write.table(results, file = "submission.csv", sep = ",", quote = FALSE, row.names = FALSE)

