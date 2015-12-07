require(extrafont)

#df <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from EXOPLANETS"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_cdt932', PASS='orcl_cdt932', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

df2 <- df %>% select(J,PLANETDISCMETH) %>% filter(J != 'null',PLANETDISCMETH %in% c('RV','Transit'))

ggplot(df2, aes(x=as.numeric(as.character(J))))+
  facet_grid(. ~ PLANETDISCMETH) +
  geom_histogram(aes(y=(..count..)/tapply(..count..,..PANEL..,sum)[..PANEL..])) +
  labs(title="Normalized Distribution of Stellar Magnitude",x="Stellar 'J' Magnitude",y=NULL)

