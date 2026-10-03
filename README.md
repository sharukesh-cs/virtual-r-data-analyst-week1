# Virtual R Data Analyst Internship - Week 1

## Project
Data Cleaning and Preliminary Analysis with R

## Dataset
R `datasets::airquality` dataset: 153 daily observations from New York, May to September 1973.
Official R documentation: https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/airquality.html

## Files
- `Week1_Data_Cleaning_and_Preliminary_Analysis.docx` - submission report
- `week1_airquality_analysis.R` - reproducible R code
- `data_raw_airquality.csv` - source data snapshot
- `data_cleaned_airquality.csv` - cleaned and transformed data
- `figures/` - supporting visualizations
- `submission_description.txt` - 200+ word submission description

## Cleaning
- Audited missing values.
- Imputed missing Ozone and Solar.R values using month-specific medians.
- Converted Month into a categorical factor.
- Detected outliers with the 1.5 x IQR rule.
- Added z-score normalized variables.
- Demonstrated categorical one-hot encoding with `model.matrix()`.

## Key results
- Raw missing values: Ozone = 37 (24.18%); Solar.R = 7 (4.58%).
- After cleaning, analysis variables contain no missing values.
- Ozone has the strongest positive correlation with Temperature (r ≈ 0.638).
- Ozone has a negative correlation with Wind (r ≈ -0.511).
- The IQR method flags 7 Ozone observations and 3 Wind observations as statistical outliers.
