## NBA Attendance Prediction
| Data Scraping | API Requests | Feature Creation & Selection | Regression Model |
| :---: | :---: | :---: | :---: | 

Before the beginning of each season, teams in the National Basketball Association have to predict attendance for the year in order to properly order and staff the arena. The main purpose of this project was to collect a wide range of statistics including in-game, team, social media, weather and census data to use for an attendance prediction model. The data covers the 2019-20, 2021-22, and 2022-23 NBA seasons and was collected through accessing a set of APIs and utilizing data scraping. Multiple features were calculated from the in-game statistics to create a final dataset with 113 features. Forward selection was used to pick a final set of 20 features, and the features were then run through a decision tree regression model from scikit-learn.

### Files

**attendance_model.ipynb** - Final notebook containing data scraping, feature selection and model

**data_collection.ipynb** - Notebook containing data collection from NBA API and American Census Survey API

