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

## Feature atranka

Šiuo metu dirbame su šiais:

```
feat_1,feat_2,feat_3, feat_5,feat_8,feat_11,feat_12,feat_14,feat_19,feat_20,feat_22,feat_24,feat_25,feat_27,feat_60,feat_62,feat_70,feat_78
```

Bandymai su h2o deeplearning panaudojant minėtus stulpus (žr. `h2o.R`):

| | local_train | local_test |
|-|-|-|
| Be atrankos | 0.4106741 | 0.6157583 |
| Su atranka | 1.020813 | 1.078613 |

Iš pirmo žvilgsnio panašu jog atranka stirpiai per grubi...

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

