OTTO chalenge
========================

[Kaggle link](https://www.kaggle.com/c/otto-group-product-classification-challenge)

## Template

Reikia pasiruošti kokybišką template kurį galėsime naudoti tolesniam modeliavimui. Reikalavimai (bus papildyta):

* Tvarkingas `test.csv` ir `train.csv` skaitymas
* Vidinis train ir test split su keičiamais parametrais ir galimybe praleisti
* Modeliavimo blokas
* Logloss estimator tiek `local_train`, tiek `local_test` vertinimui
* Tvarkingas rašymas į `submission.csv`

Pabandžiau greitai sumesti į `template.R`. Yra vienas svarbus pastebėjimas - šiuo metu padaryta classification algoritmams. Regresijos algoritmo naudojimo pavyzdys `h2o.R` vėliau galės būti perdarytas į *template*. 

**Svarbu:** modeliai su tiek kintamųjų labai daug sveria, taigi bandykite atsargiai.

## Rezultatai

`h2o.R` išbandyti modeliai (be optimizavimo):
* Deep Learning Neural Networks
* Gradient Boosted Machines
* Single-Node Random Forest
* Random Forest

| Modelis | local_train | local_test | kaggle |
|---------|-------------|------------|--------|
| h2o.deeplearning benchmark | 0.4062493 | 0.6180687 | 0.57369 |
| h2o.gbm benchmark | 0.7232466 | 0.7653265 ||
| h2o.SpeeDRF benchmark | 0.4176488 | 0.9722669 ||
| h2o.randomForest benchmark | 0.22919 | 0.769467 ||

