require 'faker'
require 'date'
require "open-uri"

puts "Cleaning database..."
Message.destroy_all
Review.destroy_all
RidePoint.destroy_all
Chatroom.destroy_all
Booking.destroy_all
Ride.destroy_all
Driver.destroy_all
User.destroy_all

puts "Creating users..."

anyelle = User.create!(email: "anyelle@email.com", password: "password", first_name: "Anyelle", last_name: "Zanatta",
                       phone_number: Faker::PhoneNumber.phone_number_with_country_code)

marieAvatar = URI.open("https://avatars.githubusercontent.com/u/167030565?s=400&u=ac460e66b84b3adfc047d64714cde1fbcf7463f4&v=4")
anyelle.photo.attach(io: marieAvatar, filename: 'anyelle.png', content_type: 'image/png')

parikaya = User.create!(email: "parikaya@email.com", password: "password", first_name: "Parikaya", last_name: "Nanda",
                        phone_number: Faker::PhoneNumber.phone_number_with_country_code)
parikayaAvatar = URI.open("https://avatars.githubusercontent.com/u/166150062?s=400&u=bf92ac6d878719e89e490376532fc7d73a19b967&v=4")
parikaya.photo.attach(io: parikayaAvatar, filename: 'parikaya.png', content_type: 'image/png')

marie = User.create!(email: "marie@email.com", password: "password", first_name: "Marie", last_name: "Auer",
  
anyelleAvatar = URI.open("https://avatars.githubusercontent.com/u/11357820?s=400&u=1666b329c10d66870bbe0d27601151ee557c8a9e&v=4")
marie.photo.attach(io: anyelleAvatar, filename: 'marie.png', content_type: 'image/png')

matilda = User.create!(email: "matilda@email.com", password: "password", first_name: "Matilda",
                       last_name: "Fritzmeier", phone_number: Faker::PhoneNumber.phone_number_with_country_code)
matildaAvatar = URI.open("https://avatars.githubusercontent.com/u/166733901?s=400&u=96579e32cc1e6c5615f395f2a9742649aa869c92&v=4")
matilda.photo.attach(io: matildaAvatar, filename: 'matilda.png', content_type: 'image/png')

puts "Finished creating users!"
puts "Creating drivers..."

driverAnyelle = Driver.create!(user: anyelle, car_model: "Tesla Model 3", car_color: "black", car_plate: "1234ABC",
                               dl_number: "1234567890")
driverParikaya = Driver.create!(user: parikaya, car_model: "Tesla Model S", car_color: "white", car_plate: "5678DEF",
                                dl_number: "0987654321")
driverMarie = Driver.create!(user: marie, car_model: "Tesla Model X", car_color: "blue", car_plate: "9012GHI",
                             dl_number: "5432167890")
driverMatilda = Driver.create!(user: matilda, car_model: "Tesla Model Y", car_color: "red", car_plate: "3456JKL",
                               dl_number: "6789054321")

puts "Finished creating drivers!"
puts "Creating rides..."

# Past Rides
ride1 = Ride.create!(origin: "Arnhem", destination: "Schipol", origin_address: "Fortunastraat 34, 6846XZ Arnhem",
                     destination_address: "Aankomstpassage 1, 1118 AX Schiphol", date: Date.new(2024, 6, 9), start_time: "12:00", remarks: "No smoking allowed", price_per_km: 0.5, seats: 3, driver: driverAnyelle)
ride2 = Ride.create!(origin: "Utrecht", destination: "Amsterdam",
                     origin_address: "Van Deventerlaan 10, 3528 AE Utrecht", destination_address: "IJsbaanpad 9, 1076 CV Amsterdam", date: Date.new(2024, 6, 10), start_time: "14:00", remarks: "No pets allowed", price_per_km: 0.6, seats: 2, driver: driverParikaya)
ride3 = Ride.create!(origin: "Rotterdam", destination: "Delft", origin_address: "Coolsingel 44, 3011 AD Rotterdam",
                     destination_address: "Kleveringweg 2, 2616 LZ Delft", date: Date.new(2024, 6, 11), start_time: "10:00", remarks: "No food allowed", price_per_km: 0.7, seats: 3, driver: driverMatilda)
ride4 = Ride.create!(origin: "Utrecht", destination: "Rotterdam", origin_address: "Lange Viestraat 3, 3511 BK Utrecht",
                     destination_address: "Coolsingel 44, 3011 AD Rotterdam", date: Date.new(2024, 6, 12), start_time: "16:00", remarks: "No loud music allowed", price_per_km: 0.8, seats: 2, driver: driverMarie)
ride5 = Ride.create!(origin: "Nijmegen", destination: "Amsterdam",
                     origin_address: "Hertog Eduardplein 4, 6663 AN Nijmegen", destination_address: "IJsbaanpad 9, 1076 CV Amsterdam", date: Date.new(2024, 6, 9), start_time: "16:00", remarks: "No loud music allowed", price_per_km: 0.8, seats: 2, driver: driverParikaya)
ride6 = Ride.create!(origin: "Amsterdam", destination: "Arnhem", origin_address: "IJsbaanpad 9, 1076 CV Amsterdam",
                     destination_address: "Fortunastraat 34, 6846XZ Arnhem", date: Date.new(2024, 6, 10), start_time: "16:00", remarks: "No loud music allowed", price_per_km: 0.8, seats: 2, driver: driverMarie)
ride7 = Ride.create!(origin: "Arnhem", destination: "Utrecht", origin_address: "Fortunastraat 34, 6846XZ Arnhem",
                     destination_address: "Lange Viestraat 3, 3511 BK Utrecht", date: Date.new(2024, 6, 11), start_time: "16:00", remarks: "No pets allowed", price_per_km: 0.8, seats: 2, driver: driverAnyelle)
ride8 = Ride.create!(origin: "Delft", destination: "Rotterdam", origin_address: "Kleveringweg 2, 2616 LZ Delft",
                     destination_address: "Coolsingel 44, 3011 AD Rotterdam", date: Date.new(2024, 6, 12), start_time: "16:00", remarks: "No pets allowed", price_per_km: 0.8, seats: 2, driver: driverMatilda)

# Future Rides
ride9 = Ride.create!(origin: "Eindhoven", destination: "Alkmaar", origin_address: "Aalsterweg 322, 5644 RL Eindhoven",
                     destination_address: "Arcadialaan 6, 1813 KN Alkmaar", date: Date.new(2024, 6, 17), start_time: "08:30", remarks: "No smoking allowed", price_per_km: 0.7, seats: 3, driver: driverMarie)
ride10 = Ride.create!(origin: "Arnhem", destination: "Haarlem", origin_address: "Fortunastraat 34, 6846XZ Arnhem",
                      destination_address: "Kennemerplein 20, 2011 MJ Haarlem", date: Date.new(2024, 6, 17), start_time: "10:00", remarks: "No loud music allowed", price_per_km: 0.5, seats: 3, driver: driverMatilda)
ride11 = Ride.create!(origin: "Nijmegen", destination: "Alkmaar",
                      origin_address: "Hertog Eduardplein 4, 6663 AN Nijmegen", destination_address: "Arcadialaan 6, 1813 KN Alkmaar", date: Date.new(2024, 6, 17), start_time: "12:00", remarks: "No loud music allowed", price_per_km: 0.8, seats: 3, driver: driverParikaya)
ride12 = Ride.create!(origin: "Tilberg", destination: "Den Helder",
                      origin_address: "Jan Heijnsstraat 10, 5041 GB Tilburg", destination_address: "Cornelis Gerritsz Geusstraat 59, 1785 EA Den Helder", date: Date.new(2024, 6, 17), start_time: "14:00", remarks: "No loud music allowed", price_per_km: 0.6, seats: 3, driver: driverAnyelle)
ride13 = Ride.create!(origin: "Eindhoven", destination: "Zaandaam",
                      origin_address: "Aalsterweg 322, 5644 RL Eindhoven", destination_address: "Ebbehout 22, 1507 EA Zaandam", date: Date.new(2024, 6, 19), start_time: "06:00", remarks: "No loud music allowed", price_per_km: 0.8, seats: 3, driver: driverMarie)

ride14 = Ride.create!(origin: "Eindhoven", destination: "Zaandaam",
                      origin_address: "Aalsterweg 322, 5644 RL Eindhoven", destination_address: "Ebbehout 22, 1507 EA Zaandam", date: Date.new(2024, 6, 16), start_time: "06:00", remarks: "No loud music allowed", price_per_km: 0.8, seats: 3, driver: driverMarie)
ride15 = Ride.create!(origin: "Eindhoven", destination: "Zaandaam",
                      origin_address: "Aalsterweg 322, 5644 RL Eindhoven", destination_address: "Ebbehout 22, 1507 EA Zaandam", date: Date.new(2024, 6, 18), start_time: "06:00", remarks: "No loud music allowed", price_per_km: 0.8, seats: 3, driver: driverMarie)
ride16 = Ride.create!(origin: "Arnhem", destination: "Haarlem", origin_address: "Fortunastraat 34, 6846XZ Arnhem",
                      destination_address: "Kennemerplein 20, 2011 MJ Haarlem", date: Date.new(2024, 6, 18), start_time: "10:00", remarks: "No loud music allowed", price_per_km: 0.5, seats: 3, driver: driverMatilda)
ride17 = Ride.create!(origin: "Arnhem", destination: "Haarlem", origin_address: "Fortunastraat 34, 6846XZ Arnhem",
                      destination_address: "Kennemerplein 20, 2011 MJ Haarlem", date: Date.new(2024, 6, 19), start_time: "10:00", remarks: "No loud music allowed", price_per_km: 0.5, seats: 3, driver: driverMatilda)
ride18 = Ride.create!(origin: "Nijmegen", destination: "Alkmaar",
                      origin_address: "Hertog Eduardplein 4, 6663 AN Nijmegen", destination_address: "Arcadialaan 6, 1813 KN Alkmaar", date: Date.new(2024, 6, 18), start_time: "12:00", remarks: "No loud music allowed", price_per_km: 0.8, seats: 3, driver: driverParikaya)
ride19 = Ride.create!(origin: "Nijmegen", destination: "Alkmaar",
                      origin_address: "Hertog Eduardplein 4, 6663 AN Nijmegen", destination_address: "Arcadialaan 6, 1813 KN Alkmaar", date: Date.new(2024, 6, 19), start_time: "12:00", remarks: "No loud music allowed", price_per_km: 0.8, seats: 3, driver: driverParikaya)

puts "Finished creating rides!"
puts "Creating bookings..."

# Past Bookings
booking1 = Booking.create(ride: ride1, user: parikaya, status: "confirmed", seats: 1, origin: "Ede",
                          origin_address: "Arnhemseweg 2A, 6711 HA Ede", destination: "Hoofddorp", destination_address: "Hoofddorp Station, 2132 Hoofddorp")
booking2 = Booking.create(ride: ride2, user: anyelle, status: "confirmed", seats: 1, origin: "Maarssen",
                          origin_address: "Maarssen Station, 3601 Maarssen", destination: "Amsterdam", destination_address: "Amsterdam Bijlmer Arena, 1102 Amsterdam")
booking3 = Booking.create(ride: ride3, user: marie, status: "confirmed", seats: 1, origin: "Rotterdam",
                          origin_address: "Euromast, Parkhaven 20, 3016 GM Rotterdam", destination: "Delft", destination_address: "Oude Kerk, Heilige Geestkerkhof 25, 2611 HP Delft")
booking4 = Booking.create(ride: ride4, user: matilda, status: "confirmed", seats: 1, origin: "Utrecht",
                          origin_address: "Rietveld Schröder House, Prins Hendriklaan 50, 3583 EP Utrecht", destination: "Rotterdam", destination_address: "Kunsthal, Westzeedijk 341, 3015 AA Rotterdam")
booking5 = Booking.create(ride: ride5, user: marie, status: "confirmed", seats: 1, origin: "Rhenen",
                          origin_address: "Vogelenzang 1, 3911 AR Rhenen", destination: "Utrecht", destination_address: "Utrecht Central Station, 3511 Utrecht")
booking6 = Booking.create(ride: ride6, user: parikaya, status: "confirmed", seats: 1, origin: "Amsterdam",
                          origin_address: "Anne Frank House, Westermarkt 20, 1016 GV Amsterdam", destination: "Arnhem", destination_address: "Openluchtmuseum, Hoeferlaan 4, 6816 SG Arnhem")
booking7 = Booking.create(ride: ride7, user: matilda, status: "confirmed", seats: 1, origin: "Arnhem",
                          origin_address: "Park Sonsbeek, 6814 Arnhem", destination: "Nieuwegein", destination_address: "Nieuwegein City Plaza, 3431 Nieuwegein")
booking8 = Booking.create(ride: ride8, user: anyelle, status: "confirmed", seats: 1, origin: "Delft",
                          origin_address: "Delft University of Technology, Mekelweg 5, 2628 CD Delft", destination: "Rotterdam", destination_address: "Rotterdam Zoo, Blijdorplaan 8, 3041 JG Rotterdam")

# Bookings Requests for Future Rides
booking9 = Booking.create(ride: ride9, user: anyelle, status: "pending", seats: 1, origin: "Eindhoven",
                          origin_address: "Aalsterweg 322, 5644 RL Eindhoven", destination: "Alkmaar", destination_address: "Arcadialaan 6, 1813 KN Alkmaar")
booking10 = Booking.create(ride: ride10, user: parikaya, status: "pending", seats: 1, origin: "Arnhem",
                           origin_address: "Fortunastraat 34, 6846XZ Arnhem", destination: "Haarlem", destination_address: "Kennemerplein 20, 2011 MJ Haarlem")
booking18 = Booking.create(ride: ride18, user: matilda, status: "pending", seats: 1, origin: "Utrecht",
                           origin_address: "Van Deventerlaan 10, 3528 AE Utrecht", destination: "Alkmaar", destination_address: "Arcadialaan 6, 1813 KN Alkmaar")
booking19 = Booking.create(ride: ride19, user: anyelle, status: "pending", seats: 1, origin: "Amsterdam",
                           origin_address: "Anne Frank House, Westermarkt 20, 1016 GV Amsterdam", destination: "Alkmaar", destination_address: "Arcadialaan 6, 1813 KN Alkmaar")

# Upcoming Bookings
booking11 = Booking.create(ride: ride11, user: marie, status: "confirmed", seats: 1, origin: "Nijmegen",
                           origin_address: "Hertog Eduardplein 4, 6663 AN Nijmegen", destination: "Utrecht", destination_address: "Van Deventerlaan 10, 3528 AE Utrecht")
booking12 = Booking.create(ride: ride12, user: matilda, status: "confirmed", seats: 1, origin: "Tilberg",
                           origin_address: "Jan Heijnsstraat 10, 5041 GB Tilburg", destination: "Den Helder", destination_address: "Cornelis Gerritsz Geusstraat 59, 1785 EA Den Helder")
booking13 = Booking.create(ride: ride13, user: parikaya, status: "confirmed", seats: 1, origin: "Eindhoven",
                           origin_address: "Aalsterweg 322, 5644 RL Eindhoven", destination: "Zaandaam", destination_address: "Ebbehout 22, 1507 EA Zaandam")
booking14 = Booking.create(ride: ride14, user: anyelle, status: "confirmed", seats: 1, origin: "Eindhoven",
                           origin_address: "Aalsterweg 322, 5644 RL Eindhoven", destination: "Zaandaam", destination_address: "Ebbehout 22, 1507 EA Zaandam")

puts "Finished creating bookings!"
puts "Creating reviews..."

review1 = Review.create!(
  comment: "Anyelle was an outstanding driver! The ride was smooth and comfortable, and she arrived right on time. The car was clean and well-maintained, making for a pleasant journey from Arnhem to Schiphol. Highly recommended!", rating: 5, booking: booking1, reviewer: parikaya, receiver: anyelle
)
review2 = Review.create!(
  comment: "Parikaya provided a fantastic experience! She was friendly and professional, ensuring that all my needs were met during the trip from Utrecht to Amsterdam. The car was spotless and the ride was very comfortable. I would definitely book with her again.", rating: 5, booking: booking2, reviewer: anyelle, receiver: parikaya
)
review4 = Review.create!(
  comment: "Matilda was a great driver. She navigated the route from Amsterdam to Arnhem with ease and kept the ride enjoyable with her friendly conversation. The car was in excellent condition, and the trip was hassle-free. Two thumbs up!", rating: 5, booking: booking3, reviewer: marie, receiver: matilda
)
review3 = Review.create!(
  comment: "Marie was a good driver and the car was clean. However, the ride could have been more comfortable if there was less noise. Overall, it was a decent experience.", rating: 4, booking: booking4, reviewer: matilda, receiver: marie
)
review5 = Review.create!(
  comment: "Parikaya did an excellent job driving from Rotterdam to Delft. She was punctual, courteous, and her car was very clean. The ride was smooth and I felt very safe throughout the journey. I would highly recommend her to anyone.", rating: 5, booking: booking5, reviewer: marie, receiver: parikaya
)
review6 = Review.create!(
  comment: "Marie was professional and the car was in good condition. However, she arrived a few minutes late and the route she took had heavy traffic. It would be great if she could plan for traffic better next time.", rating: 4, booking: booking6, reviewer: parikaya, receiver: marie
)
review7 = Review.create!(
  comment: "Any was friendly and her car was clean. However, she could improve on her punctuality as she arrived slightly late. The ride was still enjoyable, and I would consider booking with her again.", rating: 4, booking: booking7, reviewer: matilda, receiver: anyelle
)
review8 = Review.create!(
  comment: "Matilda was polite and drove safely. The car was clean but the ride could have been more comfortable if the air conditioning was working properly. Overall, a satisfactory experience.", rating: 4, booking: booking8, reviewer: anyelle, receiver: matilda
)

# Additional reviews
# review9 = Review.create!(comment: "Anyelle provided a standard ride. The car was clean and she drove safely. The journey from Arnhem to Schiphol was uneventful, which is always a good thing. No complaints.", rating: 3, booking: booking9, reviewer: marie, receiver: anyelle)
# review10 = Review.create!(comment: "Parikaya’s ride was decent. He was polite and the car was in good shape. The ride from Utrecht to Amsterdam was as expected, though nothing stood out particularly.", rating: 3, booking: booking10, reviewer: anyelle, receiver: parikaya)
# review11 = Review.create!(comment: "Marie’s service was satisfactory. She was courteous and the car was clean. The ride from Amsterdam to Arnhem was smooth. Nothing exceptional, but no issues either.", rating: 3, booking: booking11, reviewer: matilda, receiver: marie)
# review12 = Review.create!(comment: "Matilda provided a competent service. She was on time and her car was well-maintained. The trip from Rotterdam to Delft was fine, meeting all basic expectations.", rating: 3, booking: booking12, reviewer: parikaya, receiver: matilda)

puts "Finished creating reviews!"
