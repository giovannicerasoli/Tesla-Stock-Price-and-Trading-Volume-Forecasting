#Caricamento dei dati
library(readr)
TSLA <- read_csv("./Cerasoli_DelCorso_Ricchebono.csv")
summary(TSLA)

#Le variabili presenti sono:
#	Date: data nel formato anno-mese
#	Open: prezzo di apertura al primo giorno del mese di una singola azione (in $)
#	High: prezzo massimo raggiunto nel mese di una singola azione (in $)
#	Low: prezzo minimo raggiunto nel mese di una singola azione (in $)
#	Close: prezzo di chiusura all'ultimo giorno del mese di una singola azione (in $)
#	Adj-Close: prezzo di chiusura aggiustato per gli splits  e le distribuzioni dei dividendi e/o del capitale guadagnato (in $)
#	Volume: numero di azioni vendute nel mese

#BOXPLOT PER VARIABILE
ymin = min(TSLA$Low)
ymax = max(TSLA$High)
par(mfrow=c(2,3))
boxplot(TSLA$Open,main="Open", ylim=c(ymin,ymax),ylab="Dollari ($)")
boxplot(TSLA$High,main="High", ylim=c(ymin,ymax),ylab="Dollari ($)")
boxplot(TSLA$Low,main="Low", ylim=c(ymin,ymax),ylab="Dollari ($)")
boxplot(TSLA$Close,main="Close", ylim=c(ymin,ymax),ylab="Dollari ($)")
boxplot(TSLA$AdjClose,main="Adj Close", ylim=c(ymin,ymax),ylab="Dollari ($)")
boxplot(TSLA$Volume,main="Volume",ylab="Numero di azioni vendute")

#ISTOGRAMMI PER VARIABILE
par(mfrow=c(2,3))
hist(TSLA$Open,main="Open", ylim=c(0,150), xlim=c(0,500),xlab="Dollari ($)")
axis(1, at = seq(0, 500, by = 50))
hist(TSLA$High,main="High", ylim=c(0,150), xlim=c(0,500),xlab="Dollari ($)")
axis(1, at = seq(0, 500, by = 50))
hist(TSLA$Low,main="Low", ylim=c(0,150), xlim=c(0,500),xlab="Dollari ($)")
axis(1, at = seq(0, 500, by = 50))
hist(TSLA$Close,main="Close", ylim=c(0,150), xlim=c(0,500),xlab="Dollari ($)")
axis(1, at = seq(0, 500, by = 50))
hist(TSLA$AdjClose,main="Adj Close", ylim=c(0,150), xlim=c(0,500),xlab="Dollari ($)")
axis(1, at = seq(0, 500, by = 50))
hist(TSLA$Volume,main="Volume", ylim=c(0,60),xlab="Numero di azioni vendute")

#CREAZIONE SERIE TEMPORALI PER CIASCUNA VARIABILE
Open<- ts(TSLA$Open,frequency=12,start=c(2011,1)) 
is.ts(Open)
start(Open)
end(Open)
head(Open)

Close<- ts(TSLA$Close,frequency=12,start=c(2011,1)) 
is.ts(Close)
start(Close)
end(Close)
head(Close)

High<- ts(TSLA$High,frequency=12,start=c(2011,1)) 
is.ts(High)
start(High)
end(High)
head(High)

Low<- ts(TSLA$Low,frequency=12,start=c(2011,1)) 
is.ts(Low)
start(Low)
end(Low)
head(Low)

Adj_Close<- ts(TSLA$AdjClose,frequency=12,start=c(2011,1)) 
is.ts(Adj_Close)
start(Adj_Close)
end(Adj_Close)
head(Adj_Close)

Volume<- ts(TSLA$Volume,frequency=12,start=c(2011,1)) 
is.ts(Volume)
start(Volume)
end(Volume)
head(Volume)

#PLOT PER OGNI VARIABILE
par(mfrow=c(2,3))
plot(Open,main="Open",xlab="Anno",ylab="Dollari ($)")
axis(1, at = seq(2011, 2022, by = 1))
axis(2, at = seq(0, 400, by = 50))
plot(Close,main="Close",xlab="Anno",ylab="Dollari ($)")
axis(1, at = seq(2011, 2022, by = 1))
axis(2, at = seq(0, 400, by = 50))
plot(High,main="High",xlab="Anno",ylab="Dollari ($)")
axis(1, at = seq(2011, 2022, by = 1))
axis(2, at = seq(0, 400, by = 50))
plot(Low,main="Low",xlab="Anno",ylab="Dollari ($)")
axis(1, at = seq(2011, 2022, by = 1))
axis(2, at = seq(0, 400, by = 50))
plot(Adj_Close,main="Adj Close",xlab="Anno",ylab="Dollari ($)")
axis(1, at = seq(2011, 2022, by = 1))
axis(2, at = seq(0, 400, by = 50))
plot(Volume,main="Volume",xlab="Anno",ylab="Numero di azioni vendute")
axis(1, at = seq(2011, 2022, by = 1))

#STUDIO SERIE HIGH
#Trasformazione di Box-Cox con calcolo valore lambda e relativo plot
library(forecast)
library(tseries)
lambda <- BoxCox.lambda(High,lower=0)
lambda 
Highbc<-(High^lambda-1) / lambda 
par(mfrow=c(1,1))
plot.ts( Highbc,main="High Box-Cox",xlab="Anno",ylab="High Box-Cox")
axis(1, at = seq(2011, 2022, by = 1))


#Diagramma di autodispersione: confronta la serie originale con quella ritardata di 12 mesi
lag.plot(Highbc , 12)

#Grafico stagionalità
seasonplot(Highbc,year.labels = TRUE,12,col=rainbow(12),xlab="Mese",main="High Box-Cox seasonal plot")

#La funzione diff() in R calcola la differenza tra un'osservazione e quella precedente nella serie. 
#Questa operazione è utilizzata per rendere stazionaria la serie temporale
Highbcd <-  diff(Highbc)
plot(Highbcd,main="High Box-Cox differenze prime",xlab="Anno",ylab="differenze prime")
axis(1, at = seq(2011, 2022, by = 1))
lag.plot(Highbcd, 12)

#Distribuzioni normali della serie e delle trasformate con qq-plot
par(mfrow=c(1,3)) 
qqnorm(High,main="Q-Q Plot high")
qqline(High) 
qqnorm( Highbc,main="Q-Q Plot high Box-Cox" ) 
qqline( Highbc )
qqnorm( Highbcd,main="Q-Q Plot high Box-Cox 
differenze prime" ) 
qqline( Highbcd)

#Correlogrammi (ACF, PACF)
par(mfrow=c(2,2)) 
acf(High, main="High")
pacf(High, main="High")
acf(Highbcd, main="High Box-Cox differenze prime")
pacf(Highbcd, main="High Box-Cox differenze prime")

#Modello ottenuto con auto.arima() e confronto con modello ipotizzato da correlogrammi
library(tseries)
library(forecast)
library(quadprog)
library(fracdiff)
fit <- auto.arima(High)
fit
fit2 = arima(High,order=c(1,1,1))
fit2

#Analisi dei residui con plot, lag plot e correlogrammi
par(mfrow=c(1,3))
acf(resid(fit), main="Residui ARIMA(0,1,1)")
pacf(resid(fit), main="Residui ARIMA(0,1,1)") 
plot(resid(fit), main="Residui ARIMA(0,1,1)")
axis(1, at = seq(2011, 2022, by = 1))
lag.plot(resid(fit),12,do.lines=FALSE)

#Previsioni sui due anni futuri
par(mfrow=c(1,1))
forecast(fit)
plot(forecast(fit),main="Previsione High")
axis(1, at = seq(2011, 2025, by = 1))

##########################################################################

#STUDIO SERIE VOLUME
#Trasformazioni di Box-Cox con calcolo valore lambda e relativo plot
lambda <- BoxCox.lambda(Volume,lower=0)
lambda 
Volumebc<-(Volume^lambda-1) / lambda 
plot.ts( Volumebc,main="Volume Box-Cox",xlab="Anno",ylab="Volume Box-Cox")
axis(1, at = seq(2011, 2022, by = 1))

#Diagramma di autodispersione: confronta la serie originale con quella ritardata di 12 mesi
lag.plot(Volumebc , 12)

#Grafico stagionalità
seasonplot(Volumebc,year.labels = TRUE,12,col=rainbow(12),xlab="Mese",main="Volume Box-Cox seasonal plot")

#La funzione diff() in R calcola la differenza tra un'osservazione e quella precedente nella serie. 
#Questa operazione è utilizzata rendere stazionaria la serie temporale
Volumebcd <-  diff(Volumebc)
plot(Volumebcd,main=" Volume Box-Cox differenze prime ",xlab="Anno",ylab="differenze prime")
axis(1, at = seq(2011, 2022, by = 1))
lag.plot(Volumebcd, 12)

#Distribuzioni normali della serie e delle trasformate con qq-plot
par(mfrow=c(1,3)) 
qqnorm(Volume,main="Q-Q Plot volume")
qqline(Volume) 
qqnorm( Volumebc,main="Q-Q Plot volume Box-Cox" ) 
qqline( Volumebc )
qqnorm( Volumebcd,main="Q-Q Plot volume Box-Cox differenze prime" ) 
qqline( Volumebcd)

#Correlogrammi (ACF, PACF)
par(mfrow=c(2,2)) 
acf(Volume, main="Volume")
pacf(Volume, main="Volume")
acf(Volumebcd, main="Volume Box-Cox differenze prime")
pacf(Volumebcd, main="Volume Box-Cox differenze prime")

#Modello ottenuto con auto.arima() e confronto con modello ipotizzato da correlogrammi
fit <- auto.arima(Volume)
fit
fit2 = arima(Volume,order=c(1,1,1))
fit2

#Analisi dei residui con plot, lag plot e correlogrammi arima(0,1,0)
par(mfrow=c(1,3))
acf(resid(fit),main="Residui ARIMA(0,1,0)")
pacf(resid(fit),main="Residui ARIMA(0,1,0)") 
plot(resid(fit),main="Residui ARIMA(0,1,0)")
axis(1, at = seq(2011, 2022, by = 1))
lag.plot(resid(fit),12,do.lines=FALSE)

#Analisi dei residui con plot, lag plot e correlogrammi arima(1,1,1)
par(mfrow=c(1,3))
acf(resid(fit2),main="Residui ARIMA(1,1,1)")
pacf(resid(fit2),main="Residui ARIMA(1,1,1)") 
plot(resid(fit2),main="Residui ARIMA(1,1,1)")
axis(1, at = seq(2011, 2022, by = 1))
lag.plot(resid(fit2),12,do.lines=FALSE)

#Previsioni sui due anni futuri 
par(mfrow=c(1,1)) 
forecast(fit2)
plot(forecast(fit2),main="Previsione Volume")

##########################################################################

#CORRELAZIONE INCROCIATA TRA LE DUE SERIE
par(mfrow=c(1,1))
cross_correlation <- ccf (High, Volume)
print(cross_correlation)