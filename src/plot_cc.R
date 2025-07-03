source("src/Functions.R")

# Parameter
outfile <- commandArgs(trailingOnly=TRUE)[1]

# Loading
methods <- c("gw1", "gw2", "merged_gw", "qgw", "merged_qgw", "guidedpls")
params <- c("1E+8", "1E+9", "1E+10", "1E+11", "1E+12", "1E+13", "1E+14")
gdata <- data.frame(method=NULL, cc=NULL, param=NULL)
for(p in params){
    gw1 <- unlist(read.table(paste0("output/gw1/", "/", p, "/cc.csv"), header=FALSE)[,2:4])
    gw2 <- unlist(read.table(paste0("output/gw2/", "/", p, "/cc.csv"), header=FALSE)[,2:4])
    merged_gw <- unlist(read.table(paste0("output/merged_gw/", "/", p, "/cc.csv"), header=FALSE)[,2:4])
    qgw <- unlist(read.table(paste0("output/qgw/", "/", p, "/cc.csv"), header=FALSE)[,2:4])
    merged_qgw <- unlist(read.table(paste0("output/merged_qgw/", "/", p, "/cc.csv"), header=FALSE)[,2:4])
    tmp <- data.frame(
        method=c("gw1", "gw2", "merged_gw", "qgw", "merged_qgw"),
        cc=c(gw1, gw2, merged_gw, qgw, merged_qgw), param=p)
    gdata <- rbind(gdata, tmp)
}
guidedpls <- unlist(read.table("output/guidedpls/cc.csv", header=FALSE)[,2:4])
tmp <- data.frame(
    method="guidedpls",
    cc=guidedpls,
    param=NA)
gdata <- rbind(gdata, tmp)

gdata$method <- factor(gdata$method, levels=methods)

# ggplot
# Calculate mean and standard deviation for each method and sample
gdata_summary <- gdata %>%
    group_by(method) %>%
    summarise(mean_cc = mean(cc, na.rm = TRUE),
              sd_cc = sd(cc, na.rm = TRUE))

# ggplot with error bars
g <- ggplot(gdata_summary, aes(x=method, y=mean_cc, fill=method)) +
    geom_bar(stat="identity", position=position_dodge(width=0.9)) +
    geom_errorbar(aes(ymin=mean_cc-sd_cc, ymax=mean_cc+sd_cc),
                  position=position_dodge(width=0.9), width=0.25) +
    theme(axis.text.x=element_text(angle=45, hjust=1)) +
    labs(title="", x="Method", y="CC") +
    scale_fill_brewer(palette="Dark2")

ggsave(outfile, g, width=8, height=6, dpi=300)
