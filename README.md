# NHL-playoff-model

## Purpose

The purpose of this project is to create a regression model which can be used to predict the winner of any NHL playoff series. The approach taken in this project is not to compute a metric of each team's strength, but instead to directly compare the regular season statistics of the opposing teams to predict the winner of each series.

## Data Collection

Data was collected from NHL.com, corsica.hockey, and MoreHockeyStats.com

## Model

10 variables were selected to represent various dimensions of each team's regular season performance. These are Goals For%, Adjusted Goals For% (not including empty net goals), 5v5 Expected Goals For% (from corsica.hockey), 5v5 Corsi For%, 5v5 Shooting%, 5v5 Save%, Power Play%, Penalty Kill%, Average Time Spent Leading Per Game, and Number of Regulation+OT Wins.  
These variables are highly correlated, so after taking the difference between these statistics for the opposing teams in each playoff series, I run Principal Component Analysis (PCA) to extract the key dimensions of variation in the ten variables.  I use iterated 10-fold cross-validation to determine how many of these PCA components to use in the model, which for 2018 turns out to be 3.  
Now these three compound statistics are used as input variables for a logistic regression model against all completed playoff series' since the 2007-08 season.

## 2018 Results

| Higher Seed | Lower Seed | Probability of Higher Seed Winning the Series |
| ----------- | ---------- | --------------------------------------------- |
| NSH | COL | 0.756 |
| WPG	| MIN	| 0.657 |
| VGK	| L.A	| 0.435 |	
| ANA |	S.J	| 0.539 |	
| T.B	| N.J	| 0.654 |
| BOS	| TOR	| 0.695 |
| WSH	| CBJ	| 0.403 |	
| PIT	| PHI	| 0.558 |

