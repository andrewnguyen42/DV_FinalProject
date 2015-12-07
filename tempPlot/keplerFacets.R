#df <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="SELECT * from EXOPLANETS"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_cdt932', PASS='orcl_cdt932', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

keplerDiscoveriesDF <- df %>% filter (DATE_0 != 'null', PLANETDISCMETH != 'null') %>%
  group_by(DATE_0, KDE,PLANETDISCMETH) %>% summarise(discoveryCount = length(KDE)) %>% arrange(DATE_0)


ggplot(keplerDiscoveriesDF, aes(x=as.Date(DATE_0, format = '%Y'),y=discoveryCount,fill=PLANETDISCMETH))+
  geom_bar(stat="identity")+
  labs(title='Kepler vs. Non-Kepler Discoveries') +
  labs(x="Year Discovery Published", y=paste("Planet Discoveries"),fill="Discovery Method") +
  facet_grid(. ~ KDE)
