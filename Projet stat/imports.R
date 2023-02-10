#IMPORTS

require(openxlsx)
require(ggplot2)
library(rAmCharts)
require(Cairo)

#import des résultats de la présidentielle 2022
resultats_raw <- read.xlsx('Data/resultats pres 2022 communes.xlsx')
resultats_raw$codgeo <- paste(as.character(resultats_raw[,1]),as.character(resultats_raw[,3]), sep="")
resultats <- cbind(resultats_raw[,c(6, 40,54,61,68)],resultats_raw$codgeo)
names(resultats) <- c("inscrits", "EM", "MLP", "EZ", "JLM", "codgeo")
resultats$inscrits <- as.numeric(resultats$inscrits)
remove(resultats_raw)

#import RSA
rsa_raw <- read.xlsx("Data/prsa_com.xlsx")
rsa <- rsa_raw[,c(1,4)]
rsa <- rsa[which(rsa$prsa_com >=0),]
names(rsa) <- c('codgeo', 'prsa')
remove(rsa_raw)

#import IFI
ifi_raw <- read.xlsx("Data/ificom-2021.xlsx")
ifi_raw <- merge(x = ifi_raw, y= resultats, by= 'codgeo')
ifi_raw$pifi <- ifi_raw$nombre.de.redevables / ifi_raw$inscrits
ifi <- ifi_raw[,c('codgeo', 'pifi')]
remove(ifi_raw)

#import cadres
cadres_raw <- read.xlsx("Data/cadres_com.xlsx")
cadres <- cadres_raw[which(cadres_raw$an == 2018 & cadres_raw$sexe == 'T' & !(is.na(cadres_raw$p_csp_cadpis ))),c(1,5)]
names(cadres) <- c('codgeo', 'pcadres')
remove(cadres_raw)

#import QPV
qpv_raw <- read.xlsx("Data/qpv_pop.xlsx")
qpv <- qpv_raw[,c(1,3)]
qpv <- qpv[which(qpv$part_pop_qpv >0),]
names(qpv) <- c('codgeo', 'pqpv')
remove(qpv_raw)





















