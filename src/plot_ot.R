source("src/Functions.R")

# Parameter
infile1 <- commandArgs(trailingOnly=TRUE)[1]
infile2 <- commandArgs(trailingOnly=TRUE)[2]
infile3 <- commandArgs(trailingOnly=TRUE)[3]
outfile <- commandArgs(trailingOnly=TRUE)[4]

# Loading
t_source_exp <- read.csv(infile1, header=TRUE)
target_x_coordinate <- unlist(read.csv(infile2, header=FALSE))
target_y_coordinate <- unlist(read.csv(infile3, header=FALSE))

# Plot
outdir <- gsub("FINISH", "", outfile)

for(i in seq_len(ncol(t_source_exp))){
    filename = paste0(outdir, colnames(t_source_exp)[i], ".png")
    png(filename, width=1200, height=1200, bg="transparent")
    .plot_tissue_section(target_x_coordinate, target_y_coordinate,
        t_source_exp[,i], cex=3.5)
    dev.off()
}

file.create(outfile)
