#IFI

#on refait les bivariés mais mieux

#---IFI---#
deciles_ifi <- quantile(ifi$pifi, probs = seq(0.1, 0.9, by = 0.1))
res_ifi = merge(x=ifi, y=resultats, by = 'codgeo')

df_dec <- as.data.frame(matrix(nrow = 4*9, ncol = 3))
names(df_dec) <- c('dec_ifi', 'score', 'candidat')
#EM
res_dec_ifi <- list()
res_dec_ifi[[1]] <- weighted.mean(res_ifi[which(res_ifi$pifi <= deciles_ifi[1]),'EM'], res_ifi[which(res_ifi$pifi <= deciles_ifi[1]),'inscrits'])
for (i in 2:8){
  res_dec_ifi[[i]] <- weighted.mean( res_ifi[which(res_ifi$pifi <= deciles_ifi[i] & res_ifi$pifi >= deciles_ifi[i-1]),'EM'], res_ifi[which(res_ifi$pifi <= deciles_ifi[i] & res_ifi$pifi >= deciles_ifi[i-1]),'inscrits'])
}
res_dec_ifi[[9]] <- weighted.mean(res_ifi[which(res_ifi$pifi >= deciles_ifi[9]),'EM'], res_ifi[which(res_ifi$pifi >= deciles_ifi[9]),'inscrits'])

df_dec[1:9,1] <- seq(1,9)
df_dec[1:9,2] <- unlist(res_dec_ifi)
df_dec[1:9,3] <- rep("EM", 9)

#MLP
res_dec_ifi <- list()
res_dec_ifi[[1]] <- weighted.mean(res_ifi[which(res_ifi$pifi <= deciles_ifi[1]),'MLP'], res_ifi[which(res_ifi$pifi <= deciles_ifi[1]),'inscrits'])
for (i in 2:8){
  res_dec_ifi[[i]] <- weighted.mean( res_ifi[which(res_ifi$pifi <= deciles_ifi[i] & res_ifi$pifi >= deciles_ifi[i-1]),'MLP'], res_ifi[which(res_ifi$pifi <= deciles_ifi[i] & res_ifi$pifi >= deciles_ifi[i-1]),'inscrits'])
}
res_dec_ifi[[9]] <- weighted.mean(res_ifi[which(res_ifi$pifi >= deciles_ifi[9]),'MLP'], res_ifi[which(res_ifi$pifi >= deciles_ifi[9]),'inscrits'])

df_dec[10:18,1] <- seq(1,9)
df_dec[10:18,2] <- unlist(res_dec_ifi)
df_dec[10:18,3] <- rep("MLP", 9)

#EZ
res_dec_ifi <- list()
res_dec_ifi[[1]] <- weighted.mean(res_ifi[which(res_ifi$pifi <= deciles_ifi[1]),'EZ'], res_ifi[which(res_ifi$pifi <= deciles_ifi[1]),'inscrits'])
for (i in 2:8){
  res_dec_ifi[[i]] <- weighted.mean( res_ifi[which(res_ifi$pifi <= deciles_ifi[i] & res_ifi$pifi >= deciles_ifi[i-1]),'EZ'], res_ifi[which(res_ifi$pifi <= deciles_ifi[i] & res_ifi$pifi >= deciles_ifi[i-1]),'inscrits'])
}
res_dec_ifi[[9]] <- weighted.mean(res_ifi[which(res_ifi$pifi >= deciles_ifi[9]),'EZ'], res_ifi[which(res_ifi$pifi >= deciles_ifi[9]),'inscrits'])

df_dec[19:27,1] <- seq(1,9)
df_dec[19:27,2] <- unlist(res_dec_ifi)
df_dec[19:27,3] <- rep("EZ", 9)

#JLM
res_dec_ifi <- list()
res_dec_ifi[[1]] <- weighted.mean(res_ifi[which(res_ifi$pifi <= deciles_ifi[1]),'JLM'], res_ifi[which(res_ifi$pifi <= deciles_ifi[1]),'inscrits'])
for (i in 2:8){
  res_dec_ifi[[i]] <- weighted.mean( res_ifi[which(res_ifi$pifi <= deciles_ifi[i] & res_ifi$pifi >= deciles_ifi[i-1]),'JLM'], res_ifi[which(res_ifi$pifi <= deciles_ifi[i] & res_ifi$pifi >= deciles_ifi[i-1]),'inscrits'])
}
res_dec_ifi[[9]] <- weighted.mean(res_ifi[which(res_ifi$pifi >= deciles_ifi[9]),'JLM'], res_ifi[which(res_ifi$pifi >= deciles_ifi[9]),'inscrits'])

df_dec[28:36,1] <- seq(1,9)
df_dec[28:36,2] <- unlist(res_dec_ifi)
df_dec[28:36,3] <- rep("JLM", 9)

#plot ifi
g <- ggplot(df_dec, aes(x=dec_ifi, y=score)) + 
  coord_cartesian(xlim=c(1,9), ylim=c(0, 45)) +
  geom_point(aes(col=candidat), size=0.5) +
  geom_smooth(aes(col=candidat),method="loess", se=F) +
  labs(title="Le vote en fonction de la part de redevables de l'IFI", y="Part des suffrages exprimés", x="Déciles de la part dede redevables de l'IFI dans les communes", caption="Source : Ministère de l'économie et des finances/ Ministère de l'intérieur")+
  scale_color_manual(name="Candidats", 
                     labels = c("Emmanuel Macron", 
                                "Eric Zemmour",
                                "Jean-Luc Mélenchon",
                                "Marine Le Pen"),
                     values = c("EM"="#BF3EFF", 
                                "MLP"="blue", 
                                "EZ"="#8B6508", 
                                "JLM"="red")) +
  geom_hline(yintercept=27.85, linetype="dashed", color = "#BF3EFF") +
  geom_hline(yintercept=23.15, linetype="dashed", color = "blue") +
  geom_hline(yintercept=7.07, linetype="dashed", color = "#8B6508") +
  geom_hline(yintercept=21.95, linetype="dashed", color = "red") +
  theme_bw()

theme_bw()

g
ggsave(g, file="ifi lignes.png", type="cairo-png", dpi = 300, width = 20, height = 15, units = "cm")
