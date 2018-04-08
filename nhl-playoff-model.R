

## Import Data -----------------------------------------------------------------------------
corsica1 <- read.csv('corsica_5v5_08-17.csv')
corsica1$Season <- strtoi(substr(corsica1$Season, 6, 9))
corsica1 <- corsica1[, c('Team', 'Season', 'CF.', 'GF.', 'xGF.', 'Sh.', 'Sv.')]

corsica2 <- read.csv("corsica_all_08-17.csv")
corsica2$Season <- strtoi(substr(corsica2$Season, 6, 9))
corsica2 <- corsica2[, c('Team', 'Season', 'allGF.', 'allGF', 'allGA')]

stattrick <- read.csv("misc_stats_playoffwins.csv")
stattrick <- stattrick[, c('Team', 'Season', 'HDCF', 'Time.Led', 'Playoff.Wins', 'GF_EN', 'GA_EN', 'PP.', 'PK.', 'W', 'ROW')]

raw_data <- merge(merge(corsica1, corsica2, by=c("Team", "Season")), stattrick, by=c("Team", "Season"))
raw_data$adjGF. <- with(raw_data, round(100*(allGF-GF_EN)/(allGF-GF_EN+allGA-GA_EN),2))
raw_data <- raw_data[, c('Team', 'Season', 'allGF.', 'adjGF.', 'GF.', 'xGF.', 'CF.', 'HDCF', 'Time.Led', 'Sh.', 'Sv.', 'PP.', 'PK.', 'W', 'ROW', 'Playoff.Wins')]
colnames(raw_data) <- c('Team', 'Season', 'GF%', 'adjGF%', '5v5_GF%', '5v5_xGF%', '5v5_CF%', '5v5_HDCF%', 'Time_Led', '5v5_Sh%', '5v5_Sv%', 'PP%', 'PK%', 'Wins', 'ROWins', 'Playoff_Wins')

head(raw_data)

## Finalize Data -----------------------------------------------------------------------------
adj_data <- raw_data
adj_data_10 <- adj_data[adj_data$`Playoff_Wins`>=0,]
head(adj_data_10)

adj_data_5 <- adj_data_10[adj_data_10$Season>2012,]
head(adj_data_5)

## Correlations With Playoff Wins -----------------------------------------------------------------------------
stats <- colnames(adj_data_10)[4:ncol(adj_data_10)-1]
correlations_5_10 <- data.frame(matrix(ncol=13, nrow=2))
colnames(correlations_5_10) <- stats
rownames(correlations_5_10) <- c("5 years", "10 years")

correlations_5_10[1,] <- cor(adj_data_5[,4:ncol(adj_data_5)-1], adj_data_5$`Playoff_Wins`)
correlations_5_10[2,] <- cor(adj_data_10[,4:ncol(adj_data_10)-1], adj_data_10$`Playoff_Wins`)

correlations_5_10

## Correlations With Each Other -----------------------------------------------------------------------------
correlations_5 <- cor(adj_data_5[,3:ncol(adj_data_5)])
correlations_10 <- cor(adj_data_10[,4:ncol(adj_data_10)-1])

eigenspace <- eigen(correlations_10) ## 6 or 9 factors
n <- 6
C <- as.matrix(eigenspace$vectors[,1:n])
D <- matrix(0, dim(C)[2], dim(C)[2])
diag(D) <- eigenspace$values[1:n]
loadings <- C %*% sqrt(D)
loadings

S.h2 <- rowSums(loadings^2)
S.h2

S.u2 <- diag(correlations_10) - S.h2
S.u2

## Calculate Differences in Each Stat for Every Playoff Matchup -------------------------------------------------------
series <- read.csv("all_playoff_series.csv")
series$Home_Won <- round(series$Home_W., 0)

stats <- c('GF%', '5v5_xGF%', 'PK%', 'ROWins')
dStats <- stats
for (i in 1:length(stats)) {
  stat <- stats[i]
  dStat <- paste0('d', stat)
  dStats[i] <- dStat
  series[dStat] <- NA
}

regular_season_data <- adj_data_10[, c('Team', 'Season', stats)]

getDifferences <- function(row, df) {
  df_year <- df[df$Season==row$Year,]
  a1 <- df_year[as.character(df_year$Team)==as.character(row$Home),]
  a2 <- df_year[as.character(df_year$Team)==as.character(row$Away),]
  for (i in 1:length(stats)) {
    stat <- stats[i]
    dStat <- dStats[i]
    row[dStat] <- a1[[stat]] - a2[[stat]]
  }
  return(row)
}

for (row in 1:nrow(series)) {
  series[row,] <- getDifferences(series[row,], regular_season_data)
}

head(series)
colMeans(series[,dStats])