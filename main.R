
#### name: aggregation-of-slas ####
# ivanhanigan
# 2014-02-19

# TODO the recodeing using a GIS program to edit SA2s interactively
# and then join to the CCD SEIFA scores isn't working, I have just
# made it work with the old dataset I generated in PostGIS.
 
# functions
require(foreign)
 
# load
recoded_sa2s_in_newgroups  <- read.dbf("act_sa2groups_new_summary2.dbf")
analyte  <- read.dbf("cd-seifa-and-newgroups-2006.dbf")

# check
str(recoded_sa2s_in_newgroups)
str(analyte)
# analyte$notes <- as.character(analyte$notes)
 
# do
# TODO this isn't working, just make it work with the old dataset
# qc <- merge(analyte, recoded_sa2s_in_newgroups, by.x = "s2_nm_x", by.y = "sa2_name_x", all.x = T)
qc  <- analyte
str(qc)
# writing to shapefule munted the names
qc$seifa_2006_irsd_score <- qc$s_2006_
qc$new_sa2_group  <- qc$nw_s2_g
qc$outliers  <- as.character(qc$outlirs)
qc$sa2_name_x <- as.character(qc$s2_nm_x)
head(subset(qc, outliers == 'yellow'))

png("seifa-by-newgroups1.png", width = 1000, height = 700)
par(mar = c(25,4,4,1))
boxplot(split(qc$seifa_2006_irsd_score, qc$new_sa2_group), xaxt = "n", ylab = "cd2006 seifa")
labs <- names(table(qc$new_sa2_group))
segments(1:length(labs), 600, 1:length(labs), 1200, lty = 2)
text(1:length(labs), par('usr')[3], labels = labs, srt = 45, adj = c(1.1,1.1), xpd = TRUE, cex=.9)
title("cd seifa by newgroups")
#qc2 <- subset(qc, outliers == "yellow")
str(qc)
with(qc, points(as.factor(new_sa2_group), seifa_2006_irsd_score, col = qc$outliers, pch = 16))
qc$outlier_name <- ifelse(!is.na(qc$outliers), qc$sa2_name_x, "")
str(qc)
with(qc, text(as.factor(new_sa2_group), seifa_2006_irsd_score, labels = qc$outlier_name))

dev.off()

### just the crowded ones
qc2 <- qc[qc$new_sa2_group %in% c("Acton/ Braddon/ Campbell/ Civic/ Reid/ Turner",
"Fadden/ Gowrie (ACT)/ Macarthur/ Monash", "Farrer/ Isaacs/ Mawson/ Pearce/ Torrens", "Forrest/ Griffith (ACT)/ Kingston - Barton/ Narrabundah/ Red Hill (ACT)"),]
str(qc2$new_sa2_group)
qc2$new_sa2_group  <- factor(qc2$new_sa2_group)
png("seifa-by-newgroups1-2.png", width = 1000, height = 700)
par(mar = c(25,4,4,1))
boxplot(split(qc2$seifa_2006_irsd_score, qc2$new_sa2_group), xaxt = "n", ylab = "cd2006 seifa")
labs <- names(table(qc2$new_sa2_group))
segments(1:length(labs), 600, 1:length(labs), 1200, lty = 2)
text(1:length(labs), par('usr')[3], labels = labs, srt = 45, adj = c(1.1,1.1), xpd = TRUE, cex=.9)
title("cd seifa by newgroups")
#qc22 <- subset(qc2, outliers == "yellow")
#str(qc22)
with(qc2, points(as.factor(new_sa2_group), seifa_2006_irsd_score, col = qc2$outliers, pch = 16))
qc2$outlier_name <- ifelse(!is.na(qc2$outliers), qc2$sa2_name_x, "")
str(qc2)
with(qc2, text(as.factor(new_sa2_group), seifa_2006_irsd_score, labels = qc2$outlier_name))

dev.off()
