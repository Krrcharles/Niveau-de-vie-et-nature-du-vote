#ANALYSE MULTIVARIÉE V0


#------------------------IMPORTS------------------------#

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

#------------------------FIN IMPORTS------------------------#

#on refait les bivariés mais mieux

#---RSA---#
percentile_rsa <- quantile(rsa$prsa, probs = seq(.01, .99, by = .01))
res_rsa = merge(x=rsa, y=resultats, by = 'codgeo')

df_pct <- as.data.frame(matrix(nrow = 4*99, ncol = 3))
names(df_pct) <- c('pct_rsa', 'score', 'candidat')
#EM
res_perc_rsa <- list()
res_perc_rsa[[1]] <- weighted.mean(res_rsa[which(res_rsa$prsa <= percentile_rsa[1]),'EM'], res_rsa[which(res_rsa$prsa <= percentile_rsa[1]),'inscrits'])
for (i in 2:98){
  res_perc_rsa[[i]] <- weighted.mean( res_rsa[which(res_rsa$prsa <= percentile_rsa[i] & res_rsa$prsa >= percentile_rsa[i-1]),'EM'], res_rsa[which(res_rsa$prsa <= percentile_rsa[i] & res_rsa$prsa >= percentile_rsa[i-1]),'inscrits'])
}
res_perc_rsa[[99]] <- weighted.mean(res_rsa[which(res_rsa$prsa >= percentile_rsa[99]),'EM'], res_rsa[which(res_rsa$prsa >= percentile_rsa[99]),'inscrits'])

df_pct[1:99,1] <- seq(1,99)
df_pct[1:99,2] <- unlist(res_perc_rsa)
df_pct[1:99,3] <- rep("EM", 99)

#MLP
res_perc_rsa <- list()
res_perc_rsa[[1]] <- weighted.mean(res_rsa[which(res_rsa$prsa <= percentile_rsa[1]),'MLP'], res_rsa[which(res_rsa$prsa <= percentile_rsa[1]),'inscrits'])
for (i in 2:98){
  res_perc_rsa[[i]] <- weighted.mean( res_rsa[which(res_rsa$prsa <= percentile_rsa[i] & res_rsa$prsa >= percentile_rsa[i-1]),'MLP'], res_rsa[which(res_rsa$prsa <= percentile_rsa[i] & res_rsa$prsa >= percentile_rsa[i-1]),'inscrits'])
}
res_perc_rsa[[99]] <- weighted.mean(res_rsa[which(res_rsa$prsa >= percentile_rsa[99]),'MLP'], res_rsa[which(res_rsa$prsa >= percentile_rsa[99]),'inscrits'])

df_pct[100:198,1] <- seq(1,99)
df_pct[100:198,2] <- unlist(res_perc_rsa)
df_pct[100:198,3] <- rep("MLP", 99)

#EZ
res_perc_rsa <- list()
res_perc_rsa[[1]] <- weighted.mean(res_rsa[which(res_rsa$prsa <= percentile_rsa[1]),'EZ'], res_rsa[which(res_rsa$prsa <= percentile_rsa[1]),'inscrits'])
for (i in 2:98){
  res_perc_rsa[[i]] <- weighted.mean( res_rsa[which(res_rsa$prsa <= percentile_rsa[i] & res_rsa$prsa >= percentile_rsa[i-1]),'EZ'], res_rsa[which(res_rsa$prsa <= percentile_rsa[i] & res_rsa$prsa >= percentile_rsa[i-1]),'inscrits'])
}
res_perc_rsa[[99]] <- weighted.mean(res_rsa[which(res_rsa$prsa >= percentile_rsa[99]),'EZ'], res_rsa[which(res_rsa$prsa >= percentile_rsa[99]),'inscrits'])

df_pct[199:297,1] <- seq(1,99)
df_pct[199:297,2] <- unlist(res_perc_rsa)
df_pct[199:297,3] <- rep("EZ", 99)

#JLM
res_perc_rsa <- list()
res_perc_rsa[[1]] <- weighted.mean(res_rsa[which(res_rsa$prsa <= percentile_rsa[1]),'JLM'], res_rsa[which(res_rsa$prsa <= percentile_rsa[1]),'inscrits'])
for (i in 2:98){
  res_perc_rsa[[i]] <- weighted.mean( res_rsa[which(res_rsa$prsa <= percentile_rsa[i] & res_rsa$prsa >= percentile_rsa[i-1]),'JLM'], res_rsa[which(res_rsa$prsa <= percentile_rsa[i] & res_rsa$prsa >= percentile_rsa[i-1]),'inscrits'])
}
res_perc_rsa[[99]] <- weighted.mean(res_rsa[which(res_rsa$prsa >= percentile_rsa[99]),'JLM'], res_rsa[which(res_rsa$prsa >= percentile_rsa[99]),'inscrits'])

df_pct[298:396,1] <- seq(1,99)
df_pct[298:396,2] <- unlist(res_perc_rsa)
df_pct[298:396,3] <- rep("JLM", 99)


#plot RSA
g <- ggplot(df_pct, aes(x=pct_rsa, y=score)) + 
  coord_cartesian(xlim=c(0,100), ylim=c(0, 35)) +
  #geom_point(aes(col=candidat)) +
  geom_smooth(aes(col=candidat),method="gam", se=F) +
  labs(title="Le vote en fonction de la part du RSA", y="Résultats", x="Centiles de la part du RSA dans les communes", caption="INSEE RP/ Ministère de l'intérieur")+
  scale_color_manual(name="Candidats", 
                    labels = c("Emmanuel Macron", 
                                "Eric Zemmour",
                                "Jean-Luc Mélenchon",
                                "Marine Le Pen"),
                     values = c("EM"="purple", 
                                "MLP"="blue", 
                                "EZ"="#8B6508", 
                                "JLM"="red")) +
  
  geom_hline(yintercept=27.85, linetype="dashed", color = "purple") +
  geom_hline(yintercept=23.15, linetype="dashed", color = "blue") +
  geom_hline(yintercept=7.07, linetype="dashed", color = "#8B6508") +
  geom_hline(yintercept=21.95, linetype="dashed", color = "red") +
  theme_bw()


ggsave(g, file="RSA lignes.png", type="cairo-png", dpi = 300, width = 24, height = 12, units = "cm")
#---FIN RSA---#
















