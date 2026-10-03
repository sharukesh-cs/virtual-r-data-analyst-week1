# Virtual R Data Analyst Internship - Week 1
# Task: Data Cleaning and Preliminary Analysis with R
# Dataset: R datasets::airquality (New York, May-Sep 1973)
# Reproducible base-R workflow

# 1. Load dataset -----------------------------------------------------------
data(airquality, package = "datasets")
df <- airquality

# 2. Inspect structure and summary ------------------------------------------
str(df)
summary(df)
head(df)

# 3. Missing-value audit -----------------------------------------------------
missing_count <- sapply(df, function(x) sum(is.na(x)))
missing_percent <- round(100 * missing_count / nrow(df), 2)
missing_report <- data.frame(
  Variable = names(missing_count),
  Missing = as.integer(missing_count),
  Missing_Percent = missing_percent
)
print(missing_report)

# 4. Data type preparation ---------------------------------------------------
# Month is categorical for analysis, while Day remains numeric.
df$Month_Factor <- factor(
  df$Month,
  levels = 5:9,
  labels = c("May", "June", "July", "August", "September")
)

# 5. Missing-value treatment -------------------------------------------------
# Ozone and Solar.R contain missing values. Because air-quality conditions
# vary by month, month-specific medians are used rather than one global median.
median_by_month <- function(x) {
  m <- median(x, na.rm = TRUE)
  x[is.na(x)] <- m
  x
}

df_clean <- df
df_clean$Ozone <- ave(df_clean$Ozone, df_clean$Month_Factor,
                      FUN = median_by_month)
df_clean$Solar.R <- ave(df_clean$Solar.R, df_clean$Month_Factor,
                        FUN = median_by_month)

# Confirm no missing values remain in the analysis variables
print(sapply(df_clean[, c("Ozone","Solar.R","Wind","Temp")],
             function(x) sum(is.na(x))))

# 6. Descriptive statistics --------------------------------------------------
analysis_vars <- df_clean[, c("Ozone","Solar.R","Wind","Temp")]
descriptive_stats <- data.frame(
  Variable = names(analysis_vars),
  Count = sapply(analysis_vars, function(x) sum(!is.na(x))),
  Mean = sapply(analysis_vars, mean, na.rm = TRUE),
  Median = sapply(analysis_vars, median, na.rm = TRUE),
  SD = sapply(analysis_vars, sd, na.rm = TRUE),
  Min = sapply(analysis_vars, min, na.rm = TRUE),
  Max = sapply(analysis_vars, max, na.rm = TRUE)
)
descriptive_stats[, 3:7] <- round(descriptive_stats[, 3:7], 2)
print(descriptive_stats)

# 7. Outlier detection using the IQR rule -----------------------------------
outlier_report <- do.call(rbind, lapply(names(analysis_vars), function(v) {
  x <- analysis_vars[[v]]
  q1 <- quantile(x, 0.25, na.rm = TRUE)
  q3 <- quantile(x, 0.75, na.rm = TRUE)
  iqr <- q3 - q1
  lower <- q1 - 1.5 * iqr
  upper <- q3 + 1.5 * iqr
  n_out <- sum(x < lower | x > upper, na.rm = TRUE)
  data.frame(
    Variable = v, Q1 = q1, Q3 = q3, IQR = iqr,
    Lower_Bound = lower, Upper_Bound = upper,
    Outliers = n_out
  )
}))
outlier_report[, 2:6] <- round(outlier_report[, 2:6], 2)
print(outlier_report)

# 8. Z-score normalization ---------------------------------------------------
for (v in names(analysis_vars)) {
  df_clean[[paste0(v, "_z")]] <-
    as.numeric(scale(df_clean[[v]]))
}

# 9. Categorical encoding ----------------------------------------------------
# Month_Factor is one-hot encoded. The first level is used as the reference.
month_encoded <- model.matrix(~ Month_Factor - 1, data = df_clean)
head(month_encoded)

# 10. Correlation analysis ---------------------------------------------------
correlation_matrix <- round(
  cor(df_clean[, c("Ozone","Solar.R","Wind","Temp")],
      use = "complete.obs"),
  3
)
print(correlation_matrix)

# 11. Preliminary group analysis --------------------------------------------
month_summary <- aggregate(
  cbind(Ozone, Solar.R, Wind, Temp) ~ Month_Factor,
  data = df_clean,
  FUN = mean
)
print(month_summary)

# 12. Visualizations ---------------------------------------------------------
png("figures/R_missing_values.png", width=1000, height=600)
barplot(missing_count,
        main="Missing Values Before Cleaning",
        ylab="Missing Count", las=2)
dev.off()

png("figures/R_ozone_distribution.png", width=1000, height=600)
hist(df_clean$Ozone, breaks=18,
     main="Distribution of Cleaned Ozone",
     xlab="Ozone (ppb)")
dev.off()

png("figures/R_ozone_by_month.png", width=1000, height=600)
boxplot(Ozone ~ Month_Factor, data=df_clean,
        main="Ozone Distribution by Month",
        xlab="Month", ylab="Ozone (ppb)")
dev.off()

png("figures/R_ozone_vs_temperature.png", width=1000, height=600)
plot(df_clean$Temp, df_clean$Ozone,
     main="Ozone vs Temperature",
     xlab="Temperature (F)", ylab="Ozone (ppb)",
     pch=19)
abline(lm(Ozone ~ Temp, data=df_clean))
dev.off()

# 13. Export cleaned data ----------------------------------------------------
write.csv(df_clean, "data_cleaned_airquality.csv", row.names = FALSE)

cat("\nWeek 1 analysis completed successfully.\n")
