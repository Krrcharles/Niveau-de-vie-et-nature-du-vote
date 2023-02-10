# qpv

percentile_qpv <- quantile(qpv$pqpv, probs = seq(.01, .99, by = .01))
res_qpv = merge(x=qpv, y=resultats, by = 'codgeo')

df_pct <- as.data.frame(matrix(nrow = 4*99, ncol = 3))
names(df_pct) <- c('pct_qpv', 'score', 'candidat')
#EM
res_perc_qpv <- list()
res_perc_qpv[[1]] <- weighted.mean(res_qpv[which(res_qpv$pqpv <= percentile_qpv[1]),'EM'], res_qpv[which(res_qpv$pqpv <= percentile_qpv[1]),'inscrits'])
for (i in 2:98){
  res_perc_qpv[[i]] <- weighted.mean( res_qpv[which(res_qpv$pqpv <= percentile_qpv[i] & res_qpv$pqpv >= percentile_qpv[i-1]),'EM'], res_qpv[which(res_qpv$pqpv <= percentile_qpv[i] & res_qpv$pqpv >= percentile_qpv[i-1]),'inscrits'])
}
res_perc_qpv[[99]] <- weighted.mean(res_qpv[which(res_qpv$pqpv >= percentile_qpv[99]),'EM'], res_qpv[which(res_qpv$pqpv >= percentile_qpv[99]),'inscrits'])

df_pct[1:99,1] <- seq(1,99)
df_pct[1:99,2] <- unlist(res_perc_qpv)
df_pct[1:99,3] <- rep("EM", 99)

#MLP
res_perc_qpv <- list()
res_perc_qpv[[1]] <- weighted.mean(res_qpv[which(res_qpv$pqpv <= percentile_qpv[1]),'MLP'], res_qpv[which(res_qpv$pqpv <= percentile_qpv[1]),'inscrits'])
for (i in 2:98){
  res_perc_qpv[[i]] <- weighted.mean( res_qpv[which(res_qpv$pqpv <= percentile_qpv[i] & res_qpv$pqpv >= percentile_qpv[i-1]),'MLP'], res_qpv[which(res_qpv$pqpv <= percentile_qpv[i] & res_qpv$pqpv >= percentile_qpv[i-1]),'inscrits'])
}
res_perc_qpv[[99]] <- weighted.mean(res_qpv[which(res_qpv$pqpv >= percentile_qpv[99]),'MLP'], res_qpv[which(res_qpv$pqpv >= percentile_qpv[99]),'inscrits'])

df_pct[100:198,1] <- seq(1,99)
df_pct[100:198,2] <- unlist(res_perc_qpv)
df_pct[100:198,3] <- rep("MLP", 99)

#EZ
res_perc_qpv <- list()
res_perc_qpv[[1]] <- weighted.mean(res_qpv[which(res_qpv$pqpv <= percentile_qpv[1]),'EZ'], res_qpv[which(res_qpv$pqpv <= percentile_qpv[1]),'inscrits'])
for (i in 2:98){
  res_perc_qpv[[i]] <- weighted.mean( res_qpv[which(res_qpv$pqpv <= percentile_qpv[i] & res_qpv$pqpv >= percentile_qpv[i-1]),'EZ'], res_qpv[which(res_qpv$pqpv <= percentile_qpv[i] & res_qpv$pqpv >= percentile_qpv[i-1]),'inscrits'])
}
res_perc_qpv[[99]] <- weighted.mean(res_qpv[which(res_qpv$pqpv >= percentile_qpv[99]),'EZ'], res_qpv[which(res_qpv$pqpv >= percentile_qpv[99]),'inscrits'])

df_pct[199:297,1] <- seq(1,99)
df_pct[199:297,2] <- unlist(res_perc_qpv)
df_pct[199:297,3] <- rep("EZ", 99)

#JLM
res_perc_qpv <- list()
res_perc_qpv[[1]] <- weighted.mean(res_qpv[which(res_qpv$pqpv <= percentile_qpv[1]),'JLM'], res_qpv[which(res_qpv$pqpv <= percentile_qpv[1]),'inscrits'])
for (i in 2:98){
  res_perc_qpv[[i]] <- weighted.mean( res_qpv[which(res_qpv$pqpv <= percentile_qpv[i] & res_qpv$pqpv >= percentile_qpv[i-1]),'JLM'], res_qpv[which(res_qpv$pqpv <= percentile_qpv[i] & res_qpv$pqpv >= percentile_qpv[i-1]),'inscrits'])
}
res_perc_qpv[[99]] <- weighted.mean(res_qpv[which(res_qpv$pqpv >= percentile_qpv[99]),'JLM'], res_qpv[which(res_qpv$pqpv >= percentile_qpv[99]),'inscrits'])

df_pct[298:396,1] <- seq(1,99)
df_pct[298:396,2] <- unlist(res_perc_qpv)
df_pct[298:396,3] <- rep("JLM", 99)

#plot qpv
g <- ggplot(df_pct, aes(x=pct_qpv, y=score)) + 
  coord_cartesian(xlim=c(0,100), ylim=c(0, 60)) +
  geom_point(aes(col=candidat), size=0.5) +
  geom_smooth(aes(col=candidat),method="gam", se=F) +
  labs(title="Le vote en fonction de la part de résidants en QPV", y="Part des suffrages exprimés", x="Centiles de la part de résidants en QPV dans les communes", caption="Source : INSEE RP 2018/ Ministère de l'intérieur")+
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
ggsave(g, file="qpv lignes.png", type="cairo-png", dpi = 300, width = 20, height = 15, units = "cm")