source("src/Functions.R")

# Parameter
infile1 <- commandArgs(trailingOnly=TRUE)[1]
infile2 <- commandArgs(trailingOnly=TRUE)[2]
outfile <- commandArgs(trailingOnly=TRUE)[3]

# Loading
warped_exp <- read.csv(infile1, header=TRUE)
target_all_exp <- read.csv(infile2, header=TRUE)

# Correlation
out <- cor_combination(warped_exp, target_all_exp)

# Save
write.table(out, outfile, col.names=FALSE)
