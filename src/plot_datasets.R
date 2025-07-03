source("src/Functions.R")

# Parameter
infile1 <- commandArgs(trailingOnly=TRUE)[1]
infile2 <- commandArgs(trailingOnly=TRUE)[2]
infile3 <- commandArgs(trailingOnly=TRUE)[3]
infile4 <- commandArgs(trailingOnly=TRUE)[4]
infile5 <- commandArgs(trailingOnly=TRUE)[5]
infile6 <- commandArgs(trailingOnly=TRUE)[6]
infile7 <- commandArgs(trailingOnly=TRUE)[7]
infile8 <- commandArgs(trailingOnly=TRUE)[8]
infile9 <- commandArgs(trailingOnly=TRUE)[9]
infile10 <- commandArgs(trailingOnly=TRUE)[10]
outfile <- commandArgs(trailingOnly=TRUE)[11]

# Loading
source_all_exp <- read.csv(infile1, header=TRUE)
target_all_exp <- read.csv(infile2, header=TRUE)
source_exp <- read.csv(infile3, header=FALSE)
target_exp <- read.csv(infile4, header=FALSE)
source_anatomy <- read.csv(infile5, header=TRUE)
target_anatomy <- read.csv(infile6, header=TRUE)
source_x_coordinate <- unlist(read.csv(infile7, header=FALSE))
target_x_coordinate <- unlist(read.csv(infile8, header=FALSE))
source_y_coordinate <- unlist(read.csv(infile9, header=FALSE))
target_y_coordinate <- unlist(read.csv(infile10, header=FALSE))

# Flip y-axis
source_y_coordinate <- max(source_y_coordinate) - source_y_coordinate + 1

# Pre-processing
source_exp <- unlist(source_exp)
target_exp <- unlist(target_exp)

source_anatomy <- apply(source_anatomy, 1, function(x){
	colnames(source_anatomy)[which(x == max(x))[1]]
})
target_anatomy <- apply(target_anatomy, 1, function(x){
	colnames(target_anatomy)[which(x == max(x))[1]]
})

# Setting
outdir <- gsub("FINISH", "", outfile)
outfile1 = paste0(outdir, "source.png")
outfile2 = paste0(outdir, "target.png")
outfile3 = paste0(outdir, "source_log.png")
outfile4 = paste0(outdir, "target_log.png")
outfile5 = paste0(outdir, "source_density.png")
outfile6 = paste0(outdir, "target_density.png")
outfile7 = paste0(outdir, "source_log_density.png")
outfile8 = paste0(outdir, "target_log_density.png")
outfile9 = paste0(outdir, "source_anatomy.png")
outfile10 = paste0(outdir, "target_anatomy.png")

# Plot
## Slice Plot (Expression)
png(outfile1, width=1200, height=1200, bg="transparent")
.plot_tissue_section(source_x_coordinate, source_y_coordinate,
    source_exp, cex=1)
dev.off()

png(outfile2, width=1200, height=1200, bg="transparent")
.plot_tissue_section(target_x_coordinate, target_y_coordinate,
    target_exp, cex=3.5)
dev.off()

png(outfile3, width=1200, height=1200, bg="transparent")
.plot_tissue_section(source_x_coordinate, source_y_coordinate,
    log10(source_exp + 1), cex=1)
dev.off()

png(outfile4, width=1200, height=1200, bg="transparent")
.plot_tissue_section(target_x_coordinate, target_y_coordinate,
    log10(target_exp + 1), cex=3.5)
dev.off()

## Density Plot (Expression)
source_exp <- data.frame(Expression = source_exp)
g1 <- ggplot(source_exp, aes(x = Expression)) +
	geom_density(fill="red", alpha = 0.5) +
	labs(x = "Expression", y = "Density")
ggsave(outfile5, plot=g1, width = 12, height = 6, bg = "transparent")

target_exp <- data.frame(Expression = target_exp)
g2 <- ggplot(target_exp, aes(x = Expression)) +
	geom_density(fill="blue", alpha = 0.5) +
	labs(x = "Expression", y = "Density")
ggsave(outfile6, plot=g2, width = 12, height = 6, bg = "transparent")

g3 <- ggplot(log10(source_exp + 1), aes(x = Expression)) +
	geom_density(fill="red", alpha = 0.5) +
	labs(x = "Log10(Expression + 1)", y = "Density")
ggsave(outfile7, plot=g3, width = 12, height = 6, bg = "transparent")

g4 <- ggplot(log10(target_exp + 1), aes(x = Expression)) +
	geom_density(fill="blue", alpha = 0.5) +
	labs(x = "Log10(Expression + 1)", y = "Density")
ggsave(outfile8, plot=g4, width = 12, height = 6, bg = "transparent")

## Slice Plot (Anatomy)
png(outfile9, width=1200, height=1200, bg="transparent")
.plot_tissue_section2(source_x_coordinate, source_y_coordinate,
	source_anatomy, cex=1, position="topright")
dev.off()

png(outfile10, width=1200, height=1200, bg="transparent")
.plot_tissue_section2(target_x_coordinate, target_y_coordinate,
	target_anatomy, cex=3.5, position="topright")
dev.off()

# Plot
for(i in seq_len(ncol(source_all_exp))){
    filename = paste0(outdir, colnames(source_all_exp)[i], ".png")
    png(filename, width=1200, height=1200, bg="transparent")
    .plot_tissue_section(source_x_coordinate, source_y_coordinate,
        source_all_exp[,i], cex=1)
    dev.off()
}

# Marker (Target)
target_markers <- c("Mbp", "Plp1", "Mog")
for(i in target_markers){
    filename = paste0(outdir, i, ".png")
    png(filename, width=1200, height=1200, bg="transparent")
    .plot_tissue_section(target_x_coordinate, target_y_coordinate,
        target_all_exp[,i], cex=3.5)
    dev.off()
}

# Save
file.create(outfile)
