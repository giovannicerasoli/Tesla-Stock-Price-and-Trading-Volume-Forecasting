# Tesla Stock Price and Trading Volume Forecasting

Progetto realizzato per il corso di **Serie Temporali**.

## Autori

* Giovanni Giacomo Cerasoli
* Lorenzo Del Corso
* Alessandro Ricchebono

## Obiettivo

Il progetto analizza l’andamento mensile delle azioni Tesla tra gennaio 2011 e dicembre 2022.

L’obiettivo è studiare e prevedere l’evoluzione di:

```r
high
volume
```

dove:

```r
high   = prezzo massimo mensile dell’azione Tesla
volume = numero mensile di azioni scambiate
```

## Dataset

I dati sono stati raccolti da Yahoo Finance e comprendono le principali variabili finanziarie mensili:

```r
date
open
high
low
close
adj_close
volume
```

Le variabili relative al prezzo (`open`, `high`, `low`, `close`, `adj_close`) mostrano andamenti molto simili. Per questo motivo l’analisi si concentra sul massimo mensile `high` e sul volume degli scambi `volume`.

## Analisi esplorativa

L’analisi iniziale evidenzia una forte crescita dei prezzi Tesla soprattutto tra il 2020 e il 2022.

La serie `high` mostra:

* crescita contenuta fino al 2014;
* andamento relativamente stabile fino al 2020;
* incremento molto marcato nel periodo 2020-2022.

La serie `volume` presenta invece una dinamica più irregolare:

* crescita evidente tra il 2013 e il 2014;
* oscillazioni rilevanti negli anni successivi;
* picco tra il 2020 e il 2021;
* successivo ridimensionamento.

## Preprocessing delle serie

Per entrambe le variabili è stata applicata una trasformazione Box-Cox per stabilizzare la varianza.

```r
lambda ≈ 0
```

La trasformazione risulta quindi molto simile a una trasformazione logaritmica.

Successivamente, per ottenere la stazionarietà, sono state calcolate le differenze prime:

```r
diff(series)
```

Le serie differenziate mostrano una distribuzione più vicina alla normalità e non evidenziano una stagionalità mensile significativa.

## Modello per il prezzo massimo mensile

Per la serie `high`, l’analisi di ACF e PACF suggerisce un possibile modello:

```r
ARIMA(1,1,1)
```

Il confronto tramite AIC con il modello selezionato automaticamente porta però a preferire:

```r
ARIMA(0,1,1)
```

| Modello      |     AIC |
| ------------ | ------: |
| ARIMA(0,1,1) | 1258.85 |
| ARIMA(1,1,1) | 1260.57 |

Il modello scelto presenta residui compatibili con una dinamica casuale.

## Modello per il volume degli scambi

Anche per `volume`, le differenze prime rendono la serie stazionaria.

Il modello automatico suggerisce una random walk:

```r
ARIMA(0,1,0)
```

Tuttavia, il confronto tra AIC e l’analisi dei residui indicano come più adeguato:

```r
ARIMA(1,1,1)
```

| Modello      |     AIC |
| ------------ | ------: |
| ARIMA(0,1,0) | 6272.55 |
| ARIMA(1,1,1) | 6262.50 |

## Previsioni

Sono state prodotte previsioni fino a dicembre 2024, con intervalli di previsione al 80% e al 95%.

Per entrambe le serie, gli intervalli diventano progressivamente più ampi all’aumentare dell’orizzonte temporale, evidenziando l’incertezza crescente delle previsioni finanziarie di lungo periodo.

## Confronto tra prezzo e volume

Le due serie mostrano comportamenti differenti:

* `high` presenta un trend crescente più regolare, soprattutto dal 2020;
* `volume` è maggiormente volatile e caratterizzato da oscillazioni più marcate;
* non emerge una correlazione significativa tra prezzo massimo e volume nello stesso mese;
* si osservano associazioni più evidenti tra le due serie considerando ritardi superiori a quattro mesi.

## Conclusioni

Il progetto mostra come le tecniche di analisi delle serie temporali possano essere applicate a dati finanziari per studiare trend, stazionarietà, autocorrelazione e capacità previsiva.

I risultati evidenziano che:

* la trasformazione Box-Cox e le differenze prime permettono di rendere le serie più adatte alla modellazione;
* la serie dei prezzi e quella dei volumi richiedono modelli ARIMA differenti;
* il volume degli scambi presenta una dinamica più volatile rispetto ai prezzi;
* le previsioni diventano rapidamente incerte all’aumentare dell’orizzonte temporale.
