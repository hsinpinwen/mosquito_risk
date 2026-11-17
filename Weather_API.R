library(httr2)
library(dplyr)

response <- request("https://archive-api.open-meteo.com/v1/archive") |>
  req_url_query(
    latitude = 41.88,
    longitude = -87.63,
    start_date = "2023-01-01",
    end_date = "2023-12-31",
    daily = paste(
      "temperature_2m_mean",
      "temperature_2m_max",
      "temperature_2m_min",
      "precipitation_sum",
      "rain_sum",
      "relative_humidity_2m_mean",
      sep = ","
    ),
    timezone = "America/Chicago"
  ) |>
  req_perform()

data <- resp_body_json(response)


weather <- as.data.frame(
  lapply(data$daily, unlist)
)

weather$time <- as.Date(weather$time)

View(weather)