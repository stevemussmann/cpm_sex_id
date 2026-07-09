library("qqman")
library("tidyverse")

# modified from code at https://github.com/johanzi/gwas_gemma/blob/master/gemma_analysis.Rmd

# set working directory in Rstudio
setwd(dirname(rstudioapi::getSourceEditorContext()$path))

## read in file
path.file <- "cpmSex.assoc.txt"
gwas.results <- read.delim(path.file, sep="\t")


## calculate genomic inflation factor
chisq <- qchisq(1-gwas.results$P, 1)
lambda <- median(chisq) / qchisq(0.5,1)
print(lambda)

# get minimum non-zero value to transform 0 values
minNonZero <- min(gwas.results$P[gwas.results$P != 0], na.rm = TRUE)

# replace 0 values with minimum non-zero. This was done so fixed differences between sexes are identified as significant and plotted correctly
gwas.results <- gwas.results %>% mutate(P = if_else(P == 0, minNonZero, P))


# qq plot
png("dx2502_qqplot.png", width = 8, height = 8, units = "in", res=600)
qq(gwas.results$P, main="QQ Plot (sex-associated SNPs)", col="#22908c")
abline(0, 1, col = "#440d54") # Adds a red diagonal reference line
dev.off()

# Calculate Bonferroni threshold with risk 5%
## Get total number of SNPs
nb_snps <- dim(gwas.results)[[1]]

## Calculate Bonferroni corrected P-value threshold
bonferroni_threshold <- 0.05/nb_snps
threshold_pvalue <- bonferroni_threshold
gwas_significant <- subset(gwas.results, P < threshold_pvalue)

## write significant SNPs to file
write.csv(gwas_significant, "significant_snps.csv", row.names=FALSE, quote=TRUE)

## prepare list of SNPs to highlight in plot
highlighted_SNP <- gwas_significant %>% pull(SNP)

## 3 colors used are: "#5dc862" "#440d54" "#22908c"
## make manhattan plot
png("dx2502_manhattan.png", width = 15, height = 10, units = "in", res = 600)
manhattan(gwas.results, col = c("#22908c", "#5dc862"),
          #highlight=highlighted_SNP, 
          main="Colorado Pikeminnow Sex-Associated SNPs",
          suggestiveline = FALSE,
          genomewideline = FALSE,
          ylim = c(0,30))

abline(h = -log10(threshold_pvalue), col = "#440d54", lwd = 2, lty = 2)
dev.off()


# SOX10 = 9818410 to 9823265
# POLR2F = 9830908 to 9843788
png("dx2502_manhattan_chr3.png", width = 8, height = 8, units = "in", res=600)
manhattan(subset(gwas.results, CHR == 3), col = c("#22908c", "#5dc862"),
          #highlight=highlighted_SNP, 
          main="Chromosome 3",
          suggestiveline = FALSE,
          genomewideline = FALSE,
          xlim = c(9820000,9834000),
          ylim = c(0,30),
          xlab ="Position (BP)")
abline(h = -log10(threshold_pvalue), col = "#440d54", lwd = 2, lty = 2)
# line for sox10
segments(x0=9820000, y0=29.8, x1=9823265, y1=29.8, col="#5dc862", lty=1, lwd=3)
# line for POLR2F
segments(x0=9830908, y0=29.8, x1=9834000, y1=29.8, col="#5dc862", lty=1, lwd=3)
# label sox10
text(x = (9820000 + 9823265)/2, 
     y = 29.8, 
     labels = expression(italic("sox10 →")), 
     pos = 1) # pos=1 places text below the point
# label POLR2F
text(x = (9830908 + 9834000)/2, 
     y = 29.8, 
     labels = expression(italic("← polr2f")), 
     pos = 1) # pos=1 places text below the point
dev.off()

## write number of SNPs per chromosome
write.csv(as.data.frame(table(gwas.results$CHR)), "snps_per_chr.csv", row.names=TRUE, quote=FALSE)
