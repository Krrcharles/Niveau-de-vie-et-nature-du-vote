#monovariés


#--- Histogrammes ---#
theme_set(theme_classic())
g_rsa <- ggplot(rsa, aes(prsa)) +
  geom_histogram( 
               bins=50, 
               col="black", 
               size=.1) +   # change number of bins
  labs(title="Histogramme de la part d'alocataire du RSA dans les communes", 
       y="Nombre", 
       x="Part d'alocataire du RSA dans les communes", 
       caption="Source : INSEE RP 2018")

ggsave(g_rsa, file="RSA hist.png", type="cairo-png", dpi = 300, width = 20, height = 15, units = "cm")



g_ifi <- ggplot(ifi, aes(pifi)) +
  geom_histogram( 
    bins=50, 
    col="black", 
    size=.1) +   # change number of bins
  labs(title="Histogramme de redevables de l'IFI dans les communes", 
       y="Nombre", 
       x="Part de redevables de l'IFI dans les communes", 
       caption="Source : INSEE RP 2018")

ggsave(g_ifi, file="IFI hist.png", type="cairo-png", dpi = 300, width = 20, height = 15, units = "cm")

g_cadres <- ggplot(cadres, aes(pcadres)) +
  geom_histogram( 
    bins=50, 
    col="black", 
    size=.1) +   # change number of bins
  labs(title="Histogramme de la part de cadres dans les communes", 
       y="Nombre", 
       x="Part de cadres dans les communes", 
       caption="Source : INSEE RP 2018")

ggsave(g_cadres, file="cadres hist.png", type="cairo-png", dpi = 300, width = 20, height = 15, units = "cm")


g_qpv <- ggplot(qpv, aes(pqpv)) +
  geom_histogram( 
    bins=50, 
    col="black", 
    size=.1) +   # change number of bins
  labs(title="Histogramme de la part de résidants de QPV dans les communes", 
       y="Nombre", 
       x="Part de résidants de QPV dans les communes", 
       caption="Source : INSEE RP 2018")

ggsave(g_qpv, file="QPV hist.png", type="cairo-png", dpi = 300, width = 20, height = 15, units = "cm")



#--- Stats ---#





























