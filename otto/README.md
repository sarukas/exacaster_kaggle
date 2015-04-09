OTTO chalenge
========================

[Kaggle link](https://www.kaggle.com/c/otto-group-product-classification-challenge)

## Template

Reikia pasiruošti kokybišką template kurį galėsime naudoti tolesniam modeliavimui. Reikalavimai (bus papildyta):

* Tvarkingas `test.csv` ir `train.csv` skaitymas
* Vidinis train ir test split su keičiamais parametrais ir galimybe praleisti
* Modeliavimo blokas
* Logloss estimator
* Tvarkingas rašymas į `submission.csv`

Pabandžiau greitai sumesti į `template.R`. Yra vienas svarbus pastebėjimas - šiuo metu padaryta classification algoritmams. Regresijos algoritmo naudojimo pavyzdys `h2o.R` vėliau galės būti perdarytas į *template*. Reiktų jį ir komentarais papildyti.

**Svarbu:** modeliai su tiek kintamųjų labai daug sveria, taigi bandykite atsargiai.

## Rezultatai

Kaggle *uploads* rezultatai:

1. Bandymas su `h2o.R`. Realiai tikslas buvo tik užmesti akį ar viskas veikia. *Score: 0.57369*.
