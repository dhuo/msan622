require(reshape2)

data(Seatbelts)
#print(Seatbelts)

# creates x-axis for time series
times <- time(Seatbelts)
# note that 1/12 is approximately 0.0833
# note that february is 1974.083
#print(times)
# extract years for grouping later
years <- floor(times)
years <- factor(years, ordered = TRUE)
#print(years)
# extract months by looking at time series cycle
cycle(times)        # 1 through 12 for each year
#print(month.abb)    # month abbreviations
# store month abbreviations as factor
months <- factor(
  month.abb[cycle(times)],
  levels = month.abb,
  ordered = TRUE
)

# print(months)
# MOLTEN DATASET ######################

SB <- data.frame(
  year   = years,
  month  = months,
  time   = as.numeric(times),
  driverkh  = as.numeric(Seatbelts[,c('drivers')]),
  frontpkh   = as.numeric(Seatbelts[,c('front')]),
  rearpkh = as.numeric(Seatbelts[,c('rear')]), 
  vank = as.numeric(Seatbelts[,c('VanKilled')]), 
  distanced = as.numeric(Seatbelts[,c('kms')]), 
  petrolp = as.numeric(Seatbelts[,c('PetrolPrice')]), 
  laweffect = as.factor(Seatbelts[,c('law')])
)
molten <- melt(
  SB,
  id = c("year", "month", "time")
)

