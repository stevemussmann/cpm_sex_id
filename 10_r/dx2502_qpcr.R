library(tidyverse)

# set working directory in Rstudio
setwd(dirname(rstudioapi::getSourceEditorContext()$path))

pluc_035 <- read.csv("dx2502_qpcr_compiled.csv", header=TRUE)

pluc_035filt <- pluc_035 %>% as_tibble() %>% filter(Sex_Phenotype_ID_Method != "mortality" | is.na(Sex_Phenotype_ID_Method))

#cols <- c("Female" = "#440d54", "Male" = "#3b528b", "Undetermined" = "#5dc862", "NTC" = "#22908c")
cols <- c("F/F" = "#5dc862", "M/M" = "#440d54", "F/U" = "#5dc862", "F/M" = "#5dc862", "M/U" = "#440d54", "NTC" = "#22908c")

#pluc_035Discrim <- ggplot(pluc_035, aes(x=X_allele, y=Y_allele, shape=Genotype, color=Genotype)) +
pluc_035Discrim <- ggplot(pluc_035filt, aes(x=X_allele, y=Y_allele, shape=PhenoGeno, color=PhenoGeno)) + 
  geom_point(size=2.5) + 
  labs(shape = "Phenotype/Genotype", color = "Phenotype/Genotype") +
  scale_colour_manual(values=cols) +
  xlab(expression(Delta~'Rn (X Allele)'))+ 
  ylab(expression(Delta~'Rn (Y Allele)'))+ 
  ggtitle("") + 
  theme(plot.title = element_text(hjust = 0.5, face="bold"), axis.text = element_text(size = 12),
        axis.title = element_text(size = 14, face = "bold"),
        legend.text = element_text(size = 10),
        legend.title = element_text(size = 12, face = "bold")) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"))
pluc_035Discrim

plot_info <- layer_data(pluc_035Discrim)
unique(plot_info$colour)

ggsave("pluc_035_qpcr.png", dpi = 600)
