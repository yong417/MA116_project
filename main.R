setwd("/Users/yongc/Documents/MA116_project")

# create the reference sheet for connecting the company name with their SCAC --------------------
year      <- list()
reference <- c()
for (i in 1:6) {
  year[[i]] <- read.table(paste0("files/y", 2009 + i, ".txt"), sep = "\t", header = F)
  j <- ncol(year[[i]])
  reference <- rbind(reference, data.frame(company = year[[i]][, 3], scac = year[[i]][, j]))
}
reference <- reference[order(reference[, 1]), ]
reference <- unique(reference)
reference <- apply(reference, 2, as.character)

# clean the mismatch of the company -------------------------------------------------------------
for (i in 1:nrow(reference)) {
  if (reference[i, 1] == reference[i + 1, 1]) {
    print(as.character(reference[i, 1]))
    reference <- reference[-(i + 1), ]
  }
}

# following companies have multiple matched SCAC in edited sheet --------------------------------
# [1] "Canada Cartage System"
# [1] "FedEx Corp"
# [1] "NFI Industries"
# [1] "Saia Inc."
# [1] "Transport Investments Inc."

# match with the reference table ----------------------------------------------------------------
y2016 <- read.table("files/y2016.txt", header = F, sep = "\t", colClasses = "character")
y2016[, 2] <- "0"
y2016[, 3] <- "0"
for (i in 1:nrow(y2016)) {
  if (y2016[i, 1] %in% reference[, 1]) {
    y2016[i, 2] <- reference[which(reference[, 1] == y2016[i, 1]), 2]
    y2016[i, 3] <- reference[which(reference[, 1] == y2016[i, 1]), 1]
  }
  if (sub(".", "", y2016[i, 1], fixed = TRUE) %in% reference[, 1]) {
    y2016[i, 2] <- reference[which(reference[, 1] == sub(".", "", y2016[i, 1], fixed = TRUE)), 2]
    y2016[i, 3] <- reference[which(reference[, 1] == sub(".", "", y2016[i, 1], fixed = TRUE)), 1]
  }
}

# match with the scac table ---------------------------------------------------------------------
scac <- read.table("files/scac.txt", sep = "\t", header = F, colClasses = "character")
scac.initial <- unlist(lapply(scac[, 1], function(x) unlist(strsplit(x, " "))[1]))

for (i in 1:nrow(y2016)) {
  if (y2016[i, 2] == "0") {
    index <- which.max(levenshteinSim(tolower(unlist(strsplit(y2016[i, 1], " "))[1]), tolower(scac.initial)))
    y2016[i, 2] <- scac[index, 2]
    y2016[i, 3] <- scac[index, 1]
  }
}
write.table(y2016,"files/y2016_t.txt",sep="\t")

# year 2017 -------------------------------------------------------------------------------------
y2017 <- read.table("files/y2017.txt", header = F, sep = "\t", colClasses = "character")
y2017[, 2] <- "0"
y2017[, 3] <- "0"
for (i in 1:nrow(y2017)) {
  if (y2017[i, 1] %in% reference[, 1]) {
    y2017[i, 2] <- reference[which(reference[, 1] == y2017[i, 1]), 2]
    y2017[i, 3] <- reference[which(reference[, 1] == y2017[i, 1]), 1]
  }
  if (sub(".", "", y2017[i, 1], fixed = TRUE) %in% reference[, 1]) {
    y2017[i, 2] <- reference[which(reference[, 1] == sub(".", "", y2017[i, 1], fixed = TRUE)), 2]
    y2017[i, 3] <- reference[which(reference[, 1] == sub(".", "", y2017[i, 1], fixed = TRUE)), 1]
  }
}

for (i in 1:nrow(y2017)) {
  if (y2017[i, 2] == "0") {
    index <- which.max(levenshteinSim(tolower(unlist(strsplit(y2017[i, 1], " "))[1]), tolower(scac.initial)))
    y2017[i, 2] <- scac[index, 2]
    y2017[i, 3] <- scac[index, 1]
  }
}

write.table(y2017,"files/y2017_t.txt",sep="\t")

# create merged data ---------------------------------------------------------------------------
raw <- read.table("files/Merged_table.txt", header = T, sep = "\t", na.strings = "NA")
raw$Company <- as.character(raw$Company)
raw$SCAC    <- as.character(raw$SCAC)
raw <- raw[which(raw$SCAC != ""), ]
group <- aggregate(raw[, 2], list(raw$Company,raw$SCAC), mean)
colnames(group) <- c("Company", "SCAC", "AverageRevenue")

# create data for linear regression ------------------------------------------------------------
scac  <- read.table("files/scac_co2.txt", header = T, sep = "\t")
group <- group[group$SCAC %in% scac$SCAC, ]
group <- group[order(group$SCAC), ]
scac  <- scac[order(scac$SCAC), ]
trans <- cbind(group,scac)
trans <- trans[, -c(4,5)]
trans <- trans[order(trans$Company), ]
write.table(trans, file = "transCompany.txt", quote = F, sep = "\t", row.names = F)

# bulid a simple linear regression model
summary(lm(log(AverageRevenue) ~ g.mile.PM, data = trans))

summary(lm(log(AverageRevenue) ~ g.mile.PM + g.mile.CO2, data = trans))
summary(lm(log(AverageRevenue) ~ g.mile.PM + g.mile.NOx, data = trans))


summary(lm(log(AverageRevenue) ~ g.mile.CO2, data = trans))
summary(lm(log(AverageRevenue) ~ g.mile.NOx, data = trans))
summary(lm(log(AverageRevenue) ~ g.mile.PM, data = trans))







