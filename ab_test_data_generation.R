set.seed(123)

n_control <- 1000
n_treatment <- 1000

conversion_rate_control <- 0.10
conversion_rate_treatment <- 0.12

user_id_control <- 1:n_control
user_id_treatment <- (n_control + 1):(n_control + n_treatment)

group_control <- rep("Control", n_control)
group_treatment <- rep("Treatment", n_treatment)

conversion_control <- rbinom(n_control, 1, conversion_rate_control)
conversion_treatment <- rbinom(n_treatment, 1, conversion_rate_treatment)

age_control <- sample(18:65, n_control, replace = TRUE)
age_treatment <- sample(18:65, n_treatment, replace = TRUE)

locations <- c("New York", "Los Angeles", "Chicago", "Houston", "Phoenix", "Philadelphia", "San Antonio", "San Diego", "Dallas", "San Jose")
location_control <- sample(locations, n_control, replace = TRUE)
location_treatment <- sample(locations, n_treatment, replace = TRUE)

device_types <- c("Desktop", "Mobile", "Tablet")
device_type_control <- sample(device_types, n_control, replace = TRUE, prob = c(0.6, 0.3, 0.1))
device_type_treatment <- sample(device_types, n_treatment, replace = TRUE, prob = c(0.6, 0.3, 0.1))

df_control <- data.frame(
  UserID = user_id_control,
  Group = group_control,
  Conversion = conversion_control,
  Age = age_control,
  Location = location_control,
  DeviceType = device_type_control
)

df_treatment <- data.frame(
  UserID = user_id_treatment,
  Group = group_treatment,
  Conversion = conversion_treatment,
  Age = age_treatment,
  Location = location_treatment,
  DeviceType = device_type_treatment
)

ab_test_data <- rbind(df_control, df_treatment)

ab_test_data <- ab_test_data[sample(nrow(ab_test_data)), ]

write.csv(ab_test_data, "ab_test_data_v1.csv", row.names = FALSE)

head(ab_test_data)

summary(ab_test_data)

aggregate(Conversion ~ Group, data = ab_test_data, FUN = mean)


