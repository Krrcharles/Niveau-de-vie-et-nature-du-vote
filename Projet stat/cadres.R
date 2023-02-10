#Les cadres

#on refait les bivariés mais mieux

#---cadres---#
percentile_cadres <- quantile(cadres$pcadres, probs = seq(.01, .99, by = .01))
res_cadres = merge(x=cadres, y=resultats, by = 'codgeo')

df_pct <- as.data.frame(matrix(nrow = 4*99, ncol = 3))
names(df_pct) <- c('pct_cadres', 'score', 'candidat')
#EM
res_perc_cadres <- list()
res_perc_cadres[[1]] <- weighted.mean(res_cadres[which(res_cadres$pcadres <= percentile_cadres[1]),'EM'], res_cadres[which(res_cadres$pcadres <= percentile_cadres[1]),'inscrits'])
for (i in 2:98){
  res_perc_cadres[[i]] <- weighted.mean( res_cadres[which(res_cadres$pcadres <= percentile_cadres[i] & res_cadres$pcadres >= percentile_cadres[i-1]),'EM'], res_cadres[which(res_cadres$pcadres <= percentile_cadres[i] & res_cadres$pcadres >= percentile_cadres[i-1]),'inscrits'])
}
res_perc_cadres[[99]] <- weighted.mean(res_cadres[which(res_cadres$pcadres >= percentile_cadres[99]),'EM'], res_cadres[which(res_cadres$pcadres >= percentile_cadres[99]),'inscrits'])

df_pct[1:99,1] <- seq(1,99)
df_pct[1:99,2] <- unlist(res_perc_cadres)
df_pct[1:99,3] <- rep("EM", 99)

#MLP
res_perc_cadres <- list()
res_perc_cadres[[1]] <- weighted.mean(res_cadres[which(res_cadres$pcadres <= percentile_cadres[1]),'MLP'], res_cadres[which(res_cadres$pcadres <= percentile_cadres[1]),'inscrits'])
for (i in 2:98){
  res_perc_cadres[[i]] <- weighted.mean( res_cadres[which(res_cadres$pcadres <= percentile_cadres[i] & res_cadres$pcadres >= percentile_cadres[i-1]),'MLP'], res_cadres[which(res_cadres$pcadres <= percentile_cadres[i] & res_cadres$pcadres >= percentile_cadres[i-1]),'inscrits'])
}
res_perc_cadres[[99]] <- weighted.mean(res_cadres[which(res_cadres$pcadres >= percentile_cadres[99]),'MLP'], res_cadres[which(res_cadres$pcadres >= percentile_cadres[99]),'inscrits'])

df_pct[100:198,1] <- seq(1,99)
df_pct[100:198,2] <- unlist(res_perc_cadres)
df_pct[100:198,3] <- rep("MLP", 99)

#EZ
res_perc_cadres <- list()
res_perc_cadres[[1]] <- weighted.mean(res_cadres[which(res_cadres$pcadres <= percentile_cadres[1]),'EZ'], res_cadres[which(res_cadres$pcadres <= percentile_cadres[1]),'inscrits'])
for (i in 2:98){
  res_perc_cadres[[i]] <- weighted.mean( res_cadres[which(res_cadres$pcadres <= percentile_cadres[i] & res_cadres$pcadres >= percentile_cadres[i-1]),'EZ'], res_cadres[which(res_cadres$pcadres <= percentile_cadres[i] & res_cadres$pcadres >= percentile_cadres[i-1]),'inscrits'])
}
res_perc_cadres[[99]] <- weighted.mean(res_cadres[which(res_cadres$pcadres >= percentile_cadres[99]),'EZ'], res_cadres[which(res_cadres$pcadres >= percentile_cadres[99]),'inscrits'])

df_pct[199:297,1] <- seq(1,99)
df_pct[199:297,2] <- unlist(res_perc_cadres)
df_pct[199:297,3] <- rep("EZ", 99)

#JLM
res_perc_cadres <- list()
res_perc_cadres[[1]] <- weighted.mean(res_cadres[which(res_cadres$pcadres <= percentile_cadres[1]),'JLM'], res_cadres[which(res_cadres$pcadres <= percentile_cadres[1]),'inscrits'])
for (i in 2:98){
  res_perc_cadres[[i]] <- weighted.mean( res_cadres[which(res_cadres$pcadres <= percentile_cadres[i] & res_cadres$pcadres >= percentile_cadres[i-1]),'JLM'], res_cadres[which(res_cadres$pcadres <= percentile_cadres[i] & res_cadres$pcadres >= percentile_cadres[i-1]),'inscrits'])
}
res_perc_cadres[[99]] <- weighted.mean(res_cadres[which(res_cadres$pcadres >= percentile_cadres[99]),'JLM'], res_cadres[which(res_cadres$pcadres >= percentile_cadres[99]),'inscrits'])

df_pct[298:396,1] <- seq(1,99)
df_pct[298:396,2] <- unlist(res_perc_cadres)
df_pct[298:396,3] <- rep("JLM", 99)

#plot cadres
g <- ggplot(df_pct, aes(x=pct_cadres, y=score)) + 
  coord_cartesian(xlim=c(0,100), ylim=c(0, 35)) +
  geom_point(aes(col=candidat), size=0.5) +
  geom_smooth(aes(col=candidat),method="gam", se=F) +
  labs(title="Le vote en fonction de la part des cadres des communes", y="Part des suffrages exprimés", x="Centiles de la part des cadres dans les communes", caption="Source : INSEE RP 2018/ Ministère de l'intérieur")+
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
ggsave(g, file="cadres lignes.png", type="cairo-png", dpi = 300, width = 20, height = 15, units = "cm")
