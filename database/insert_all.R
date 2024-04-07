library(dplyr)
set.seed(123)
base_time <- as.POSIXct("2024-05-03 00:00:00")

indices_to_keep <- sample(1:220, 25)  # reduce 220 airports to 25 airports
iata_airlines1 <- iata_airlines %>% filter(row_number() %in% indices_to_keep)

row.names(iata_airlines1) <- NULL		# reset the row names of the new dataframe
write.csv(iata_airlines1, "reduced_airlines.csv", row.names = FALSE)

# --------------------------------------------------

# Sample data
existing_addresses <- eaddress$Address
existing_cities <- eaddress$City
existing_states <- eaddress$State

# Calculate the number of additional unique addresses needed
num_additional <- 1500 - length(existing_addresses)

# Sample additional addresses from existing ones
additional_addresses <- sample(existing_addresses, num_additional, replace = TRUE)

# Modify the first digit of the additional addresses to ensure uniqueness
random_digits <- sample(1:9, num_additional, replace = TRUE)

# Initialize vector to store modified additional addresses
modified_additional_addresses <- character()

# Replace the first digit of each address with a random digit
for (i in 1:num_additional) {
  modified_additional_addresses <- c(modified_additional_addresses, paste0(random_digits[i], substring(additional_addresses[i], 2)))
}

# Sample additional cities and states from existing ones
additional_cities <- sample(existing_cities, num_additional, replace = TRUE)
additional_states <- sample(existing_states, num_additional, replace = TRUE)

# Combine existing and modified additional addresses, cities, and states
combined_addresses <- c(existing_addresses, modified_additional_addresses)
combined_cities <- c(existing_cities, additional_cities)
combined_states <- c(existing_states, additional_states)
random_ssn <- sample(emp_final$SSN, 1500, replace = TRUE)

# Create dataframe with combined data
eaddress_final <- data.frame(SSN = random_ssn, Street = combined_addresses, City = combined_cities, District = combined_states)
write.csv(eaddress_final, "eaddress_final.csv", row.names = FALSE)

# -------------------------------------------------------

AirplaneID <- 1:50

AirlineID <- sample(iata_airlines1$AirlineID, 50, replace = TRUE)

# Randomly select OwnerID from df1$OwnerID and cooperation
OwnerID <- sample(c(sample(df1$OwnerID, 42, replace = TRUE), sample(81:100, 8, replace = TRUE)), 50, replace = TRUE)

# Generate random dates for LeasedDate
LeasedDate <- as.Date(sample(seq(as.Date("1990-01-01"), as.Date("2023-12-31"), by="day"), 50, replace=TRUE))

# Randomly select MName from model$Name
ModelID <- sample(model$X, 50, replace = TRUE)

generate_license_plate <- function() {
  paste0(paste0(sample(LETTERS, 2), collapse = ""), "-", paste0(sample(c(0:9, LETTERS), 3, replace = TRUE), collapse = ""))
}
License_plate_num <- replicate(50, generate_license_plate())
License_plate_num <- unique(License_plate_num)
License_plate_num <- License_plate_num[1:50]

# Create the dataframe
new_airplane_0504 <- data.frame(
  AirplaneID = AirplaneID,
  License_plate_num = License_plate_num,
  AirlineID = AirlineID,
  OwnerID = OwnerID,
  LeasedDate = LeasedDate,
  ModelID = ModelID
)

# View the dataframe
View(new_airplane_0504)

write.csv(new_airplane_0504, "airplanes_0504.csv", row.names = FALSE)

sampled_ap_codes <- sample(new_airport_new$APCode, 50, replace = TRUE)

# Sample 500 APCode randomly from new_df
sampled_airplane_ids <- sample(new_airplane_0504$AirplaneID, 50, replace = FALSE)

# Create the dataframe airport_contains_airplane
airport_contains_airplane <- data.frame(APCode = sampled_ap_codes,
                                        AirplaneID = sampled_airplane_ids)

write.csv(airport_contains_airplane, "contains.csv", row.names = FALSE)


# ---------------------------------------------------

library(dplyr)
# Calculate the number of employees for each category
num_admin_support <- 100
num_engineer <- 200
num_flight_attendant <- 150
num_pilot <- 150
num_traffic_controller <- 100

# Split employees based on Emp_Records$SSN
administrative_support <- emp_final[sample(nrow(emp_final), num_admin_support), ]
emp_final1 <- emp_final[!(emp_final$SSN %in% administrative_support$SSN), ]

engineer <- emp_final1[sample(nrow(emp_final1), num_engineer), ]
emp_final2 <- emp_final1[!(emp_final1$SSN %in% engineer$SSN), ]

flight_employee <- emp_final2[sample(nrow(emp_final2), num_flight_attendant + num_pilot), ]
emp_final3 <- emp_final2[!(emp_final2$SSN %in% flight_employee$SSN), ]

traffic_controller <- emp_final3[sample(nrow(emp_final3), num_traffic_controller), ]

pilot <- flight_employee[sample(nrow(flight_employee), num_pilot), ]
flight_attendant <- flight_employee[!(flight_employee$SSN %in% pilot$SSN), ]


# Assuming you have a list of airports named airports_list
airports_list <- unique(new_airport$APCode)
# Distribute employees to ensure each airport has at least 2 employees of each type
num_remain <- 700
emp_final5 <- emp_final
administrative_support1 <- administrative_support
engineer1 <- engineer
flight_attendant1 <- flight_attendant
pilot1 <- pilot
traffic_controller1 <- traffic_controller
total_req <- data.frame()
for (airport in airports_list) {
  # Sample 2 employees from each category
  admin_support_sample <- administrative_support1[sample(nrow(administrative_support1), 2), ]
  engineer_sample <- engineer1[sample(nrow(engineer1), 2), ]
  flight_attendant_sample <- flight_attendant1[sample(nrow(flight_attendant1), 2), ]
  pilot_sample <- pilot1[sample(nrow(pilot1), 2), ]
  traffic_controller_sample <- traffic_controller1[sample(nrow(traffic_controller1), 2), ]
  
  administrative_support1 <- administrative_support1[!(administrative_support1$SSN %in% admin_support_sample$SSN), ]
  engineer1 <- engineer1[!(engineer1$SSN %in% engineer_sample$SSN), ]
  flight_attendant1 <- flight_attendant1[!(flight_attendant1$SSN %in% flight_attendant_sample$SSN), ]
  pilot1 <- pilot1[!(pilot1$SSN %in% pilot_sample$SSN), ]
  traffic_controller1 <- traffic_controller1[!(traffic_controller1$SSN %in% traffic_controller_sample$SSN), ]
  
  airport_data <- rbind(admin_support_sample, engineer_sample, flight_attendant_sample, pilot_sample, traffic_controller_sample)
  airport_data <- data.frame(APCode = airport, SSN = airport_data$SSN, Date = airport_data$Date)
  total_req <- rbind(total_req, airport_data)
  emp_final5 <- anti_join(emp_final5, airport_data, by = "SSN")
}

administrative_support$ASType <- sample(c("Secretary", "Data Entry", "Receptionist", "Communications", "PR", "Security", "Ground Service", "HR", "Emergency Service"), nrow(administrative_support), replace = TRUE)
engineer$EType <- sample(c("Avionic Engineer", "Mechanical Engineer", "Electric Engineer"), nrow(engineer), replace = TRUE)
flight_attendant$Year_experience <- round(runif(nrow(flight_attendant), min = 0.5, max = 5), 1)
pilot$License <- sample(100000000000:999999999999, nrow(pilot), replace = FALSE)

shifts <- c("Morning", "Afternoon", "Evening", "Night")
TCShift <- data.frame(SSN = sample(traffic_controller$SSN, 150, replace = TRUE))

TCShift <- TCShift %>%
  group_by(SSN) %>%
  mutate(Shift = sample(shifts, n(), replace = TRUE))


write.csv(administrative_support, "adsupport_new.csv", row.names = FALSE)
write.csv(engineer, "engineer_new.csv", row.names = FALSE)
write.csv(flight_employee, "fe_new.csv", row.names = FALSE)
write.csv(flight_attendant, "fa_new.csv", row.names = FALSE)
write.csv(pilot, "pilot_new.csv", row.names = FALSE)
write.csv(traffic_controller, "tc_new.csv", row.names = FALSE)
write.csv(TCShift, "tcshift_new.csv", row.names = FALSE)


# -------------------------------------------------------------------

engineer_expertise_model <- data.frame(
  ESSN = sample(engineer$SSN[3:195], 400, replace = TRUE), 
  ModelID = sample(model$X, 400, replace = TRUE))
#engineer_expertise_model <- unique(engineer_expertise_model)

while (TRUE) {
  engineer_expertise_model$ESSN <- sample(engineer$SSN[3:195], 400, replace = TRUE)
  engineer_expertise_model$ModelID <- sample(model$X, 400, replace = TRUE)
  engineer_expertise_model <- unique(engineer_expertise_model)
  
  if (length(unique(engineer_expertise_model$ModelID)) < length(model$X)) next
  break
}

engineer_expertise_model <- unique(engineer_expertise_model)

write.csv(engineer_expertise_model, "expertise.csv", row.names = FALSE)

# -------------------------------------------------------


experts_at <- data.frame(
  ConsultID = sample(consultant$ID, 100, replace = TRUE),
  APCode = sample(new_airport_new$APCode[2:15], 100, replace = TRUE),
  ModelID = sample(model$X[2:28], 100, replace = TRUE)
)


experts_at$ConsultID <- sample(consultant$ID, 100, replace = TRUE)
experts_at$APCode <- sample(new_airport_new$APCode[2:15], 100, replace = TRUE)
experts_at$ModelID = sample(model$X[2:28], 100, replace = TRUE)

experts_at <- unique(experts_at)

write.csv(experts_at, "experts_at.csv", row.names = FALSE)

# -----------------------------------------------------

# Generate all possible combinations of airport pairs
airport_pairs <- combn(new_airport_new$APCode, 2, simplify = TRUE)

# Create a dataframe with auto-incremented IDs and routes
base_routes_df <- data.frame(
  Route = apply(airport_pairs, 2, paste, collapse = "-")
)

rvs_routes_df <- base_routes_df %>%
  mutate(Route = gsub("(.{3})-(.{3})", "\\2-\\1", Route))

routes_df <- rbind(base_routes_df, rvs_routes_df)

# Function to calculate distance using Haversine formula
calculate_distance <- function(lat1, lon1, lat2, lon2) {
  # Earth radius in kilometers
  R <- 6371 
  
  # Convert latitude and longitude from degrees to radians
  lat1_rad <- lat1 * pi / 180
  lon1_rad <- lon1 * pi / 180
  lat2_rad <- lat2 * pi / 180
  lon2_rad <- lon2 * pi / 180
  
  # Haversine formula
  dlon <- lon2_rad - lon1_rad
  dlat <- lat2_rad - lat1_rad
  a <- sin(dlat/2)^2 + cos(lat1_rad) * cos(lat2_rad) * sin(dlon/2)^2
  c <- 2 * atan2(sqrt(a), sqrt(1-a))
  distance <- R * c
  
  return(distance)
}

# Calculate distances for each route in the routes_df data frame
routes_df$Distance <- sapply(strsplit(routes_df$Route, "-"), function(x) {
  dep_airport <- x[1]
  dest_airport <- x[2]
  
  dep_coords <- new_airport_new[new_airport_new$APCode == dep_airport, c("Latitude", "Longitude")]
  dest_coords <- new_airport_new[new_airport_new$APCode == dest_airport, c("Latitude", "Longitude")]
  
  calculate_distance(dep_coords$Latitude, dep_coords$Longitude, dest_coords$Latitude, dest_coords$Longitude)
})

routes_df$ID <- 1:210

# Print the routes_df data frame with distances
View(routes_df)

write.csv(routes_df, "routes_new.csv", row.names = FALSE)


# -----------------------------------------------

# Load necessary libraries
library(dplyr)
library(lubridate)

current_time <- Sys.time()
min_date <- current_time - days(3)
max_date <- current_time + days(3)

# Generate flight data
flight <- data.frame(
  FlightID = 1:120,
  RID = sample(routes_df$ID, 120, replace = TRUE),
  Status = NA,
  AirplaneID = sample(new_airplane_0504$AirplaneID, 120, replace = TRUE),
  TCSSN = NA,
  FlightCode = NA,
  EDT = NA,
  EAT = NA,
  ADT = NA,
  AAT = NA
)

random_seconds <- sample(seq(min_date, max_date, by = 1), 120, replace = TRUE)

flight$EDT <- as.POSIXct(random_seconds, origin = "1970-01-01")

# Generate ADT, EAT, AAT based on EDT
default_time <- as.POSIXct('1970-01-01 00:00:00')

for (i in 1:nrow(flight)) {
  random_num_a <- runif(1)
  random_num_b <- runif(1)
  flight$ADT[i] <- ifelse(flight$EDT[i] < current_time, min(flight$EDT[i] + sample(-3600:3600, 1), current_time), default_time)
  flight$EAT[i] <- flight$EDT[i] + sample(10800:36000, 1)
  flight$AAT[i] <- ifelse((flight$ADT[i] == default_time || flight$ADT[i] > current_time - hours(3)), default_time, min(flight$EAT[i] + sample(-3600:3600, 1), current_time))
}

flight$ADT <- as.POSIXct(flight$ADT, origin = "1970-01-01")
flight$AAT <- as.POSIXct(flight$AAT, origin = "1970-01-01")
flight$EAT <- as.POSIXct(flight$EAT, origin = "1970-01-01")

flight$TCSSN <- NA

for (i in 1:nrow(flight)) {
  edt <- hour(flight$EDT[i])
  shift <- ifelse(edt >= 0 & edt <= 5, "Night",
                  ifelse(edt >= 6 & edt <= 11, "Morning",
                         ifelse(edt >= 12 & edt <= 17, "Afternoon", "Evening")))
  available <- filter(TCShift, Shift == shift)
  selected_tcssn <- sample(available$SSN, 1, replace = TRUE)
  flight$TCSSN[i] <- selected_tcssn
}

#get_status <- function(actual_dep_time, actual_arr_time, expected_dep_time) {
#  if (current_time >= actual_dep_time && current_time <= actual_arr_time) {
#    return("On Air")
#  } else if (current_time < expected_dep_time - hours(2)) {
#    return("Unassigned")
#  } else {
#    return("Landed")
#  }
#}

get_status <- function(actual_dep_time, actual_arr_time, expected_dep_time) {
  if (actual_dep_time == default_time || current_time < expected_dep_time - hours(2)) return("Unassigned")
  else {
    if (actual_arr_time == default_time) return ("On Air")
    else return("Landed")
  }
}

# Add Status column to flight data frame
flight$Status <- mapply(get_status, flight$ADT, flight$AAT, flight$EDT)

# Retrieve IATA designators from iata_airlines based on AirplaneID
flight_airplane <- flight %>% inner_join(new_airplane_0504, by = "AirplaneID")

# Join flight_airplane with iata_airlines based on iata_airlines.airlineid = airplane.airlineid
final_df <- flight_airplane %>% inner_join(iata_airlines1, by = "AirlineID")

airline_designators <- final_df$IATADesignator[final_df$AirplaneID == flight$AirplaneID]

# Create a storage for keeping track of the last used number for each prefix
last_numbers <- list()

# Function to generate auto-incremented variables for each prefix
generate_variable <- function(prefix) {
  if (is.vector(prefix)) {
    result <- vector("list", length(prefix))
    for (i in seq_along(prefix)) {
      p <- prefix[i]
      if (!(p %in% names(last_numbers))) {
        last_numbers[[p]] <- 101
      } else {
        last_numbers[[p]] <- last_numbers[[p]] + 1
      }
      result[[i]] <- paste0(p, last_numbers[[p]])
    }
    return(unlist(result))
  } else {
    if (!(prefix %in% names(last_numbers))) {
      last_numbers[[prefix]] <- 1
    } else {
      last_numbers[[prefix]] <- last_numbers[[prefix]] + 1
    }
    return(paste0(prefix, last_numbers[[prefix]]))
  }
}

# Combine airline designators and flight codes to create FlightCode
#flight$FlightCode <- paste0(airline_designators, flight_codes)
flight$FlightCode <- generate_variable(airline_designators)

# Extract numeric part
numeric_part <- gsub("[^0-9]", "", flight$FlightCode)

# Zero-padding
padded_numeric_part <- sprintf("%04d", as.numeric(numeric_part))

# Combine prefix with padded numeric part
flight$FlightCode <- paste0(gsub("[0-9]", "", flight$FlightCode), padded_numeric_part)

flight$BasePrice <- round(runif(120, min = 0.05, max = 0.08), 3)

# Sample the data
View(flight)
write.csv(flight, "flight_ultimate.csv", row.names = FALSE)


# ---------------------------------------------

library(dplyr)
library(lubridate)

# ---------------------------INSERT SEATS--------------------------------
enum_class <- c("Economy", "Business", "First Class")
enum_status <- c("Unavailable", "Available")

merged_data <- flight %>%
  inner_join(new_airplane_0504, by = "AirplaneID") %>%
  inner_join(model, by = c("ModelID" = "X")) %>%
  distinct()

total_numseats <- sum(round(0.75 * merged_data$Capacity))

seat_df_unique <- unique(seat_df)
prob_each <- rep(1/length(flight$FlightID), length(flight$FlightID))
sampled_values <- sample(flight$FlightID, total_numseats, replace = TRUE, prob = prob_each)
#table(sampled_values)

Seat <- data.frame(
  FlightID = sampled_values,
  Class = sample(enum_class, total_numseats, replace = TRUE),
  Status = rep("Unavailable", total_numseats)
)

Seat <- Seat %>%
  group_by(FlightID) %>%
  mutate(SeatNum = head(seat_df_unique$Seat_Number, n()))

View(Seat)


# ---------------------------INSERT TICKETS--------------------------------

min_date1 <- current_time - days(90)
max_date1 <- current_time + days(1)

Ticket <- data.frame(
  TicketID = seq(1, total_numseats),
  PID = sample(passenger$PID, total_numseats, replace = TRUE),
  FlightID = sample(flight$FlightID, total_numseats, replace = TRUE)
)

random_secs <- sample(seq(min_date1, max_date1, by = 1), total_numseats, replace = TRUE)

Ticket$BookTime <- as.POSIXct(random_secs, origin = "1970-01-01")

merged_data_ultimate <- merged_data %>%
  inner_join(Seat, by = "FlightID") %>%
  inner_join(routes_df, by = c("RID" = "ID")) %>%
  distinct()


ratio_case1_to_case2 <- 1 / 5
random_numbers <- runif(nrow(Ticket))
threshold_case1 <- ratio_case1_to_case2 / (1 + ratio_case1_to_case2)
default_time <- as.POSIXct('1970-01-01 00:00:00')

Ticket <- Ticket %>%
  mutate(
    CheckInTime = ifelse(random_numbers <= threshold_case1,
                         default_time,
                         as.POSIXct(merged_data_ultimate$EDT - runif(n()) * (24 * 3600 - 15 * 60))),
    CheckInStatus = ifelse(CheckInTime == default_time, "No", "Yes")
  )

Ticket$CheckInTime <- as.POSIXct(Ticket$CheckInTime, origin = "1970-01-01")

Ticket <- Ticket %>%
  group_by(FlightID) %>%
  mutate(SeatNum = head(seat_df_unique$Seat_Number, n()))

economy_coefficient <- 0.7
business_coefficient <- 1
first_class_coefficient <- 1.2

merged_data_ultimate <- merged_data_ultimate %>%
  mutate(
    Price = ifelse(merged_data_ultimate$Class == "Economy", merged_data_ultimate$BasePrice * economy_coefficient * merged_data_ultimate$Distance,
                   ifelse(merged_data_ultimate$Class == "Business", merged_data_ultimate$BasePrice * business_coefficient * merged_data_ultimate$Distance,
                          merged_data_ultimate$BasePrice * first_class_coefficient * merged_data_ultimate$Distance))
  )

Ticket$Price <- round(merged_data_ultimate$Price, 1)

View(Ticket)

write.csv(Seat, "seats.csv", row.names = FALSE)
write.csv(Ticket, "tickets.csv", row.names = FALSE)


# ---------------------------------------------------

roles <- character()
operates <- data.frame(
  FSSN = sample(flight_employee$SSN, nrow(flight), replace = TRUE),
  FlightID = sample(flight$FlightID, nrow(flight), replace = FALSE)
)

for (ssn in operates$FSSN) {
  # Check if the SSN is in the Pilot table
  if (ssn %in% pilot$SSN) roles <- c(roles, "Pilot")
  else roles <- c(roles, "FA")
}
operates$Role <- roles
write.csv(operates, "operates.csv", row.names = FALSE)

# -----------------------------------------------------

SSN <- sample(emp_final$SSN, nrow(emp_final), replace = FALSE)

# Sample SSN for SuperSSN column (not unique)
SuperSSN <- sample(emp_final$SSN, nrow(emp_final), replace = TRUE)

# Create dataframe
Supervision <- data.frame(SSN = SSN, SuperSSN = SuperSSN)
write.csv(Supervision, "super.csv", row.names = FALSE)

# --------------------------------------------------

sampled_ap_codes <- sample(new_airport_new$APCode, nrow(emp_final) - 20, replace = TRUE)
sampled_SSN <- sample(emp_final$SSN, nrow(emp_final) - 20, replace = FALSE)
date <- sample(emp_final$Date, nrow(emp_final) - 20, replace = TRUE)
airport_includes_employee <- data.frame(APCode = sampled_ap_codes, SSN = sampled_SSN, Date = date)
airport_includes_employee <- rbind(airport_includes_employee, total_req)

write.csv(airport_includes_employee, "includes.csv", row.names = FALSE)

# ---------------------------------------------------

source_df <- data.frame(RID = routes_df$ID, SourceAirport = substr(routes_df$Route, 1, 3))
dest_df <- data.frame(RID = routes_df$ID, DestinationAirport = substr(routes_df$Route, 5, 7))
write.csv(source_df, "sourceAP.csv", row.names = FALSE)
write.csv(dest_df, "destAP.csv", row.names = FALSE)
