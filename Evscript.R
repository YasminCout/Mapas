.libPaths("C:/Rstudio/R/win-library/4.0")



library(auk)
library(sf)
library(dplyr)
library(ggplot2)
library(rnaturalearth)
library(rnaturalearthdata)
library(rgeos)
library(ggspatial)


worldmap <- ne_countries(scale = 'medium', type = 'map_units',
                         returnclass = 'sf')
poly <- worldmap[worldmap$continent == 'South America',]

auk_ebd("data/ebd_varfly_RelMay-2020.txt") %>% 
  auk_bbox(poly)

f_out <- "data/ebd_varfly_filter.txt"
auk_ebd("data/ebd_varfly_relMay-2020.txt") %>%
  auk_bbox(poly) %>%
  auk_date(c("*-04-01", "*-08-31")) %>%
  auk_complete() %>%
  auk_filter(f_out)

auk_ebd("data/ebd_varfly_RelMay-2020.txt") %>% 
  auk_bbox(poly)

f_dados <- "data/ebd_varfly_south.txt"
auk_ebd("data/ebd_varfly_relMay-2020.txt") %>%
  auk_bbox(poly) %>%
  auk_complete() %>%
  auk_filter(f_dados)




#Remove duplicate group checklists
ebd <- read_ebd("data/ebd_varfly_filter.txt")


dados <- read_ebd("data/ebd_varfly_south.txt")


ggplot() +
  geom_sf(data = poly, color = "gray3", fill = "transparent") +
  annotation_scale() +
  annotation_north_arrow(location = "tr", which_north = "true", 
                         pad_x = unit(0.1, "in"), pad_y = unit(0.04, "in"),
                         style = north_arrow_fancy_orienteering) +
  geom_point(data = dados, aes(x = longitude, y = latitude, color = "Verão"), size = 1.6) +
  geom_point(data = ebd, aes(x = longitude, y = latitude, color = "Inverno"), size = 1.6)+
  scale_colour_manual(name = "Estação",
                      breaks = c("Verão", "Inverno"),
                      values = c("Verão" = "firebrick3", "Inverno" = "darkturquoise") )+
  ggtitle("Empidonomus Varius")+
  xlab("") + ylab("") +
  theme(panel.grid.major = element_line(colour = gray(0.6), 
                                       size = 0.5, linetype = "solid"),
        panel.background = element_rect(fill = "gray100"),
        panel.border = element_rect(fill = "NA"),
        legend.title=element_text(size=18),
        legend.text=element_text(size=16),
        text=element_text(family="serif", size=17),
        legend.background = element_rect(fill="gray98", 
                                         size=0.5, linetype="solid", color = "black"),
        legend.position = "right")
        
        




