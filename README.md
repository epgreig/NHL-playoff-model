# NHL-playoff-model

## 2018 Predictions

### First Round
| Higher Seed | Lower Seed | Probability of Higher Seed Winning the Series |
| ----------- | ---------- | --------------------------------------------- |
| NSH | COL | 75.6% |
| WPG	| MIN	| 65.7% |
| VGK	| L.A	| 43.5% |	
| ANA |	S.J	| 53.9% |	
| T.B	| N.J	| 65.4% |
| BOS	| TOR	| 69.5% |
| WSH	| CBJ	| 40.3% |	
| PIT	| PHI	| 55.8% |

### Later Rounds
Probabilities for future rounds will be released as the matchups are set. If you are curious, if the model is run for the entire playoff, the result is NSH 52.9% of beating BOS in the final.


## Purpose

The purpose of this project is to create a regression model which can be used to predict the winner of any NHL playoff series. The approach taken in this project is not to compute a metric of each team's strength, but instead to directly compare the regular season statistics of the opposing teams to predict the winner of each series.

## Data Collection

Data was collected from NHL.com, corsica.hockey, and MoreHockeyStats.com

## Model

10 variables were selected to represent various dimensions of each team's regular season performance. These are Goals For%, Adjusted Goals For% (not including empty net goals), 5v5 Expected Goals For% (from corsica.hockey), 5v5 Corsi For%, 5v5 Shooting%, 5v5 Save%, Power Play%, Penalty Kill%, Average Time Spent Leading Per Game, and Number of Regulation+OT Wins.  
These variables are highly correlated, and therefore are not well suited to be used directly as logistic regression variables. So after taking the difference between these statistics for the opposing teams in each playoff series, I run Principal Component Analysis (PCA) to extract the key dimensions of variation in the ten variables.  I use iterated 10-fold cross-validation to determine how many of these uncorrelated PCA components to use in the model (to find a balance between using maximum information while not overfitting the training set), which for 2018 turns out to be 3.  
Now these three compound statistics are used as input variables for a logistic regression model against all completed playoff series' since the 2007-08 season.  

## Principal Components
In general, Principal Component Analysis results in transformations to the variables which are non-intuitive. However, my model luckily resulted in some components which have real-world interpretations.

|	dGF%	|dAdjGF%	|d5v5_xGF%|d5v5_CF%	|dTime_Led|d5v5_Sh%	|d5v5_Sv%	|dPP%	|dPK%	|dROWins |
|-------|---------|---------|---------|---------|---------|---------|-----|-----|--------|
|Comp.1	|0.48	|0.47	|0.23	|0.20	|0.41	|0.21	|0.04	|0.21	|0.09	|0.44|
|Comp.2	|-0.05	|-0.05	|0.53	|0.60	|-0.04	|-0.49	|-0.27	|-0.09	|0.16	|-0.13|
|Comp.3	|0.19	|0.19	|-0.10	|0.01	|-0.13	|-0.19	|0.60	|-0.53	|0.47	|-0.05|
