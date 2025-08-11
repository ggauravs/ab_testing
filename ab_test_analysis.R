ab_test_data <- read.csv("ab_test_data.csv")

head(ab_test_data)
str(ab_test_data)
summary(ab_test_data)

ab_test_data$Group <- as.factor(ab_test_data$Group)

conversion_summary <- aggregate(Conversion ~ Group, data = ab_test_data, FUN = function(x) c(mean = mean(x), sd = sd(x), n = length(x)))
print(conversion_summary)

contingency_table <- table(ab_test_data$Group, ab_test_data$Conversion)
print(contingency_table)

chi_square_test <- chisq.test(contingency_table)
print(chi_square_test)

p_value <- chi_square_test$p.value
alpha <- 0.05

cat("\nChi-square Test Results:\n")
cat("P-value: ", p_value, "\n")
cat("Significance Level (alpha): ", alpha, "\n")

if (p_value < alpha) {
  cat("The p-value (", p_value, ") is less than the significance level (", alpha, ").\n")
  cat("Therefore, we reject the null hypothesis. There is a statistically significant difference in conversion rates between the Control and Treatment groups.\n")
} else {
  cat("The p-value (", p_value, ") is greater than or equal to the significance level (", alpha, ").\n")
  cat("Therefore, we fail to reject the null hypothesis. There is no statistically significant difference in conversion rates between the Control and Treatment groups.\n")
}

conversions_control <- contingency_table["Control", "1"]
n_control_total <- sum(contingency_table["Control", ])

conversions_treatment <- contingency_table["Treatment", "1"]
n_treatment_total <- sum(contingency_table["Treatment", ])

prop_test_result <- prop.test(
  x = c(conversions_control, conversions_treatment),
  n = c(n_control_total, n_treatment_total),
  conf.level = 0.95
)

print(prop_test_result)

cat("\nConfidence Interval for Difference in Proportions:\n")
cat("95% Confidence Interval: ", round(prop_test_result$conf.int[1], 4), " to ", round(prop_test_result$conf.int[2], 4), "\n")
cat("Interpretation: We are 95% confident that the true difference in conversion rates (Treatment - Control) lies within this interval.\n")

mean_conversions <- aggregate(Conversion ~ Group, data = ab_test_data, FUN = mean)

barplot(
  height = mean_conversions$Conversion,
  names.arg = mean_conversions$Group,
  ylim = c(0, max(mean_conversions$Conversion) * 1.2),
  main = "Average Conversion Rate by Group",
  xlab = "Group",
  ylab = "Conversion Rate",
  col = c("skyblue", "lightgreen")
)
text(x = barplot(mean_conversions$Conversion, plot = FALSE), y = mean_conversions$Conversion, 
     labels = round(mean_conversions$Conversion, 3), pos = 3, cex = 0.8)

conversion_by_device <- aggregate(Conversion ~ Group + DeviceType, data = ab_test_data, FUN = mean)
print(conversion_by_device)

conversion_by_location <- aggregate(Conversion ~ Group + Location, data = ab_test_data, FUN = mean)
conversion_by_location_control_ordered <- conversion_by_location[conversion_by_location$Group == "Control", ]
conversion_by_location_control_ordered <- conversion_by_location_control_ordered[order(-conversion_by_location_control_ordered$Conversion), ]
print(head(conversion_by_location_control_ordered, 5))

ab_test_data$AgeGroup <- cut(ab_test_data$Age, breaks = c(18, 25, 35, 45, 55, 65), 
                               labels = c("18-24", "25-34", "35-44", "45-54", "55-65"), right = FALSE)
conversion_by_age <- aggregate(Conversion ~ Group + AgeGroup, data = ab_test_data, FUN = mean)
print(conversion_by_age)


