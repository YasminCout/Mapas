library(auk)
library(sf)
library(dplyr)
library(ggplot2)
library(rnaturalearth)
library(rnaturalearthdata)
library(rgeos)
library(ggspatial)

#Mapa geral
world <- ne_countries(scale = "medium", returnclass = "sf")

#Inverno
f_out <- "data/ebd_xolmiscinv.txt"

auk_ebd("data/ebd_grymon1_relAug-2020.txt") %>%
  # define filters
  auk_date(c("*-04-01", "*-08-31")) %>% 
  # compile and run filters
  auk_filter(f_out, overwrite = TRUE)

inverno <- read_ebd("data/ebd_xolmiscinv.txt")

#Verão - Parte 1
f_out <- "data/ebd_xolmiscv.txt"

auk_ebd("data/ebd_grymon1_relAug-2020.txt") %>%
  # define filters
  auk_date(c("*-01-01", "*-03-31")) %>%
  # compile and run filters
  auk_filter(f_out, overwrite = TRUE)

verao1 <- read_ebd("data/ebd_xolmiscv.txt")

#Verão - Parte 2

f_out <- "data/ebd_xolmiscv2.txt"

auk_ebd("data/ebd_grymon1_relAug-2020.txt") %>%
  # define filters
  auk_date(c("*-09-01", "*-12-31")) %>%
  # compile and run filters
  auk_filter(f_out, overwrite = TRUE)

verao2 <- read_ebd("data/ebd_xolmiscv2.txt")

#Juntar os dois dados do verão

verao <- rbind(verao1,verao2)

#Plot
ggplot() +
  geom_sf(data = world, color = "gray3", fill = "transparent") +
  coord_sf(xlim = c(-109.4, -26.2), ylim = c(-58.5, 12.6), expand = FALSE)+
  annotation_scale(location = "bl", width_hint = 0.4) +
  annotation_north_arrow(location = "tl", which_north = "true", 
                         height = unit(2.0, "cm"),
                         width = unit(2.0, "cm"),
                         pad_x = unit(0.2, "cm"),
                         pad_y = unit(0.3, "cm"),
                         style = north_arrow_fancy_orienteering) +
  geom_point(data = verao, aes(x = longitude, y = latitude, color = "Verão (Set.- Mar.)"), size = 1.2, shape = 19) +
  geom_point(data = inverno, aes(x = longitude, y = latitude, color = "Inverno (Abr.- Ago.)"), size = 1.2, shape = 19)+
  scale_colour_manual(name = "Estação",
                      breaks = c("Verão (Set.- Mar.)", "Inverno (Abr.- Ago.)"),
                      values = c("Verão (Set.- Mar.)" = "firebrick3", "Inverno (Abr.- Ago.)" = "darkturquoise") )+
  ggtitle("Xolmis Cinereus")+
  xlab("") + ylab("") +
  theme(panel.grid.major = element_line(colour = gray(0.6), 
                                        size = 0.5, linetype = "solid"),
        panel.background = element_rect(fill = "gray100"),
        panel.border = element_rect(fill = "NA"),
        legend.title=element_text(size=18),
        legend.text=element_text(size=15),
        text=element_text(family="serif", size=17),
        legend.background = element_rect(fill="gray98", 
                                         size=0.5, linetype="solid", color = "black"),
        legend.position = "right")
        
        




