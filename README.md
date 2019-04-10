# NHL-playoff-model

## Purpose

The purpose of this project is to create a model which can be used to predict the winner of any NHL playoff series. The approach taken in this project is not to compute a metric of each team's strength, but instead to directly compare the regular season statistics of the opposing teams to predict the winner of each series.

## Data Collection

Data was collected from corsica.hockey, NaturalStatTrick.com, foxsports.com,and MoreHockeyStats.com

## 2019 Model Development

This year, instead of a PCA model (see README in directory: "2018") I decided to try two other types of model: Random Forest and Elastic Net Logistic Regression. First, I train and tune benchmark models, and measure a cross-validated average Log Loss for each model. Then I do some feature selection to extract smaller subsets of salient features. This is crucial because many of the features were highly correlated (which is not ideal for a random forest model) and with just 165 historical matchups in the training set, it is very easy to overfit with the full set of 32 features. A few subsets are then tuned and their performance is measured with each type of model.

After backtesting the model on the 2018 season, I realized that the model was giving strangely asymmetric results. For example, if the model predicts the same series twice with the Home/Away teams swapped, it will often predict that the Away team will win in both scenarios. This is because the Home team is overwhelmingly more likely to have better stats than the Away team in a playoff series, so the model has a positively skewed perception of what the average stat differences should be for two evenly-matched teams.

I eliminated this effect by duplicating every series with the Home/Away perspective swapped in every training set. So the model no longer has an idea of Home Advantage (I tried adding this as a variable but it was not predictive), and in a sense it is training on twice as much data though that data contains the equal and opposite information of the original data. This symmetrized model has the benefit of giving nearly identical results when the Home/Away teams are swapped, and actually performed much better in cross validation in terms of Accuracy and Log-Loss!

## 2019 Best Model

In the end, elastic net (with mostly L1-regularization, a slight amount of L2-regularization) did outperform the classic logistic regression but the best model was the Random Forest (regression-type) on a set of 5 features representing the matchup difference in: GF% in all situations, GF% in 5v5 situations, expected GF% in all situations, CF/60 in 5v5 situations, and PK%. This model (with the hyperparameters mtry=1, nodesize=44) results in an average Log Loss of 0.619 (this number contains slight leakage because the entire training set was used to tune the hyperparameters, but I ensured that all CV test sets do not contain an equal-opposite data point to any series in the training set).

## Order of Files

1. import_data
2. import_and_generate_series
3. cross_validation
4. benchmark_models
5. elastic_net_tuning
6. random_forest_tuning
7. benchmark_models_tuned
8. rf_feature_selection
9. rf_final_tuning
10. predict_2019

## 2019 Predictions

CGY v COL    78.3%

S.J v VGK    44.0%

NSH v DAL    57.5%

WPG v STL    36.9%

T.B v CBJ    79.6%

BOS v TOR    36.3%

WSH v CAR    37.4%

NYI v PIT    36.1%
