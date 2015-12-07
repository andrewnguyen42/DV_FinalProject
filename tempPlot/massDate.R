#df <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from EXOPLANETS"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_cdt932', PASS='orcl_cdt932', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

df2 <- df %>% select(DATE_0,MASS,PLANETDISCMETH) %>% filter(DATE_0 != 'null', MASS != 'null',PLANETDISCMETH != 'null')

require(extrafont)

ggplot() +
  coord_cartesian() + 
  scale_x_continuous() +
  scale_y_log10() +
  labs(title="Mass of Discovered Planets Over Time",y="Mass of Planet (Jupiter Mass)",x="Year Published",color="Method of Discovery")+
  layer(data=df2,
    mapping=aes(x=as.numeric(as.character(DATE_0)),y=as.numeric(as.character(MASS)),color=PLANETDISCMETH),
    stat="identity",
    stat_params=list(),
    geom="point",
    geom_params=list(),
    position = position_jitter(width=0.5, height=0)
  )
