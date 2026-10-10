# Virtual R Data Analyst Internship - Week 2
# Data Visualization and Insight Communication using R

# Install required packages if they are missing
packages <- c("ggplot2", "dplyr")

for (pkg in packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg)
  }
}

library(ggplot2)
library(dplyr)

# Load the built-in airquality dataset
data("airquality")

# Create a clean dataset
air_data <- airquality %>%
  mutate(
    Month = factor(
      Month,
      levels = 5:9,
      labels = c("May", "June", "July", "August", "September")
    )
  )

# Create an output folder
dir.create("week2_plots", showWarnings = FALSE)

# 1. Missing values visualization
missing_data <- data.frame(
  Variable = names(airquality),
  Missing = colSums(is.na(airquality))
)

p1 <- ggplot(missing_data,
             aes(x = Variable, y = Missing)) +
  geom_col(fill = "steelblue") +
  labs(
    title = "Missing Values by Variable",
    x = "Variable",
    y = "Number of Missing Values"
  ) +
  theme_minimal()

ggsave("week2_plots/01_missing_values.png",
       p1, width = 8, height = 5)

# 2. Ozone distribution histogram
p2 <- ggplot(air_data, aes(x = Ozone)) +
  geom_histogram(
    bins = 20,
    fill = "skyblue",
    color = "black",
    na.rm = TRUE
  ) +
  labs(
    title = "Distribution of Ozone Levels",
    x = "Ozone",
    y = "Frequency"
  ) +
  theme_minimal()

ggsave("week2_plots/02_ozone_distribution.png",
       p2, width = 8, height = 5)

# 3. Monthly ozone distribution
p3 <- ggplot(air_data,
             aes(x = Month, y = Ozone)) +
  geom_boxplot(fill = "lightgreen", na.rm = TRUE) +
  labs(
    title = "Ozone Levels Across Months",
    x = "Month",
    y = "Ozone"
  ) +
  theme_minimal()

ggsave("week2_plots/03_ozone_by_month.png",
       p3, width = 8, height = 5)

# 4. Ozone versus temperature
p4 <- ggplot(air_data,
             aes(x = Temp, y = Ozone)) +
  geom_point(color = "darkblue", na.rm = TRUE) +
  geom_smooth(method = "lm",
              se = TRUE, na.rm = TRUE) +
  labs(
    title = "Ozone Levels vs Temperature",
    x = "Temperature (F)",
    y = "Ozone"
  ) +
  theme_minimal()

ggsave("week2_plots/04_ozone_vs_temperature.png",
       p4, width = 8, height = 5)

# 5. Correlation matrix
numeric_data <- airquality[
  , sapply(airquality, is.numeric)
]

cor_matrix <- cor(
  numeric_data,
  use = "pairwise.complete.obs"
)

png("week2_plots/05_correlation_matrix.png",
    width = 900, height = 700)

heatmap(
  cor_matrix,
  main = "Air Quality Variable Correlation Matrix",
  col = colorRampPalette(
    c("blue", "white", "red")
  )(100),
  symm = TRUE
)

dev.off()

# Print summary and observations
cat("\nWEEK 2 DATA VISUALIZATION SUMMARY\n")
cat("---------------------------------\n")

print(summary(airquality))

cat("\nMissing values by variable:\n")
print(missing_data)

cat("\nCorrelation matrix:\n")
print(round(cor_matrix, 2))

cat("\nAll five visualization plots have been generated.\n")
cat("Check the week2_plots folder for the images.\n")
