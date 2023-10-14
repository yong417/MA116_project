setwd("/Users/yongc/Documents/MA116_project")

# read in the data ----------------------------------------------------------------------------------------------
raw <- read.table("files/Merged_table.txt", header = T, sep = "\t", na.strings = "NA", stringsAsFactors = FALSE)
scac <- read.table("files/scac_co2.txt", header = T, sep = "\t", stringsAsFactors = FALSE)
scac <- scac[order(scac$SCAC), ]

# boxplot -------------------------------------------------------------------------------------------------------
grp <- c()
for (year in as.character(unique(raw$Year))) {
  data <- raw[raw$Year == year, ]
  data <- data[data$SCAC %in% scac$SCAC, ]
  data <- data[order(data$SCAC), ]
  data <- cbind(data, scac[scac$SCAC %in% data$SCAC, ])
  data <- data[, c(2, 8)]
  data <- data[order(data$Revenue, decreasing = TRUE), ]
  grp <- rbind(grp, data)
}

grp$Year <- as.factor(grp$Year)
ggplot(grp, aes(x = Year, y = log(Revenue))) +
  stat_boxplot(geom="errorbar",size=1)+
  geom_boxplot(lwd = 1, fatten = 1 , fill = ("#E69F00"))+
  scale_x_discrete(name = "Year") +
  scale_y_continuous(name = "log(Revenue)") +
  ggtitle("Outlier checking for normality") +
  theme_bw() + theme_classic()+
  theme(plot.title = element_text(size = 14, family = "Tahoma", face = "bold", hjust = 0.5),
        text = element_text(size = 12, family = "Tahoma"),
        axis.title = element_text(face = "bold"),
        axis.text.x = element_text(size = 8, face = "bold"),
        axis.text.y = element_text(size = 8, face = "bold"),
        legend.text = element_text(size = 10, face = "bold"),
        legend.title = element_text(size = 10, face = "bold"),
        legend.position = "bottom")

# QQ-plot -------------------------------------------------------------------------------------------------------
par(mfrow=c(2,4))
for (year in as.character(unique(raw$Year)[order(unique(raw$Year))])) {
  data <- raw[raw$Year == year, ]
  data <- data[data$SCAC %in% scac$SCAC, ]
  data <- data[order(data$SCAC), ]
  data <- cbind(data, scac[scac$SCAC %in% data$SCAC, ])
  data <- data[, c(2, 8)]
  data <- data[order(data$Revenue, decreasing = TRUE), ]
  qqPlot(log(data$Revenue), ylab = "log(Revenue)", xlab = "Norm Quantiles", main = year)
}

for (year in as.character(unique(raw$Year)[order(unique(raw$Year))])) {
  data <- raw[raw$Year == year, ]
  data <- data[data$SCAC %in% scac$SCAC, ]
  data <- data[order(data$SCAC), ]
  data <- cbind(data, scac[scac$SCAC %in% data$SCAC, ])
  data <- data[, c(2, 8)]
  data <- data[order(data$Revenue, decreasing = TRUE), ]
  if (year == "2014") {
    data <- data[-(1:3), ]
  } else {
    data <- data[-(1:2), ]
  }
  qqPlot(log(data$Revenue), ylab = "log(Revenue)", xlab = "Norm Quantiles", main = year)
}

par(mfrow=c(1,1))

# abstract the information for a given year ---------------------------------------------------------------------
year <- 2018

# match the scac with the corresponding companies
data <- raw[raw$Year == year, ]
data <- data[data$SCAC %in% scac$SCAC, ]
data <- data[order(data$SCAC), ]
data <- cbind(data, scac[scac$SCAC %in% data$SCAC, ])
data <- data[, c(1:2, 7:8, 11:13)]
data <- data[order(data$Revenue, decreasing = TRUE), ]
data <- data[-(1:2), ]

# data checking
apply(combn(5:7, 2), 2, function(x) cor(data[, x[1]], data[, x[2]]))

summary(lm(log(data$Revenue) ~ g.mile.CO2 + g.mile.NOx + g.mile.PM, data = data))
summary(lm(log(data$Revenue) ~ g.mile.CO2 + g.mile.PM, data = data))

AIC(lm(log(data$Revenue) ~ g.mile.CO2, data = data))
AIC(lm(log(data$Revenue) ~ g.mile.NOx, data = data))
AIC(lm(log(data$Revenue) ~ g.mile.PM, data = data))
AIC(lm(log(data$Revenue) ~ g.mile.CO2 + g.mile.NOx, data = data))
AIC(lm(log(data$Revenue) ~ g.mile.CO2 + g.mile.PM, data = data))
AIC(lm(log(data$Revenue) ~ g.mile.NOx + g.mile.PM, data = data))
AIC(lm(log(data$Revenue) ~ g.mile.CO2 + g.mile.NOx + g.mile.PM, data = data))


######
# get summary data for gee
######
merge <- c()
for (year in as.numeric(names(table(raw$Year)))) {
  data <- raw[raw$Year == year, ]
  data <- data[data$SCAC %in% scac$SCAC, ]
  data <- data[order(data$SCAC), ]
  data <- cbind(data, scac[scac$SCAC %in% data$SCAC, ])
  data <- data[, c(1:2, 7:8, 11:13)]
  data <- data[order(data$Revenue, decreasing = TRUE), ]
  data <- data[-(1:2), ]
  merge <- rbind(merge, data)
}

merge <- merge[order(merge$Company), ]

index <- c()
name <- ""
for (i in 1:nrow(merge)) {
  if (merge[i, 1] != name) {
    count <- 1
    name <- merge[i, 1]
  } else {
    count <- count + 1
  }
  index <- c(index, count)
}


