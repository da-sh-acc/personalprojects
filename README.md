# Personal Projects

This is a repository that contains analytical projects i've completed. I've pursued topics I find personally interesting as a means of both learning more about the topic and practicing my skills in data collection, analysis and visualization. 

## COVID-19: A Pandemic In Review
| Data Analysis | Data Visualization |
| :---: | :---: |

Over the course of the pandemic, I became interested in learning about how COVID-19 was affecting the US and especially how it affected different parts of the country. This project explores Covid data from 2021 and 2020 to highlight the overall trends and seasonality of case numbers using a multitude of visualizations. The media cycle constantly focused on large states like New York and California due to the number of overall cases, but I wanted to examine each state using scaled statistics to better understand how the pandemic affected each indvidual state. The data was collected from the [Johns Hopkins CSSE Covid-19 Data Repository](https://github.com/CSSEGISandData/COVID-19).

## NBA Attendance Prediction
| Data Scraping | API Requests | Feature Creation & Selection | Regression Model |
| :---: | :---: | :---: | :---: | 

Before the beginning of each season, teams in the National Basketball Association have to predict attendance for the year in order to properly order and staff the arena. The main purpose of this project was to collect a wide range of statistics including in-game, team, social media, weather and census data to use for an attendance prediction model. The data covers the 2019-20, 2021-22, and 2022-23 NBA seasons and was collected through accessing a set of APIs and utilizing data scraping. Multiple features were calculated from the in-game statistics to create a final dataset with 113 features. Forward selection was used to pick a final set of 20 features, and the features were then run through a decision tree regression model from scikit-learn. 

## NBA Database Data Collection
| Data Collection | Database Management |
| :---: | :---: | 

This notebook aggregates NBA Data through the [NBA API Python Package](https://pypi.org/project/nba-api/), cleans and converts the data into pandas dataframes and then stores the tables in a sqlite database. The tables will also be dumped into a SQL File so that it can be imported into any database system. The purpose of this project was to practice skills in API data collection and database management, and was influenced by previous practice work done with the [European Soccer Dataset](https://www.kaggle.com/datasets/hugomathien/soccer). This data is the start of an incomplete project, the focus of which is building a team-based dashboard that tracks game statistics, schedule and player information during the NBA Season. 

## Olist Dashboard
| Data Analysis | SQL | Dashboard Visualization | Tableau
| :---: | :---: | :---: | :---: |

The dashboard contains various order and revenue statistics of data from Olist, a Brazilian E-Commerce company. The [Olist dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) was collected from Kaggle and has the information of 100,000 orders from 2016 to 2018. The SQL file contains various data exploration queries and analysis to discover the main drivers of revenue for the company. The final dashboard was created in Tableau and posted on [Tableau Public](https://public.tableau.com/app/profile/david.shin8483/viz/olist_dashboard/Dashboard1)
