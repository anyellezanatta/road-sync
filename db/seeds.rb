require 'faker'
require 'date'
require "open-uri"

puts "Cleaning database..."
Message.destroy_all
Booking.destroy_all
Review.destroy_all
Ride.destroy_all
Driver.destroy_all
User.destroy_all

puts "Creating users..."

anyelle = User.create!(email: "anyelle@email.com", password: "password", first_name: "Anyelle", last_name: "Zanatta",
                       phone_number: Faker::PhoneNumber.phone_number_with_country_code)
anyelleAvatar = URI.open("https://avatars.githubusercontent.com/u/11357820?s=400&u=1666b329c10d66870bbe0d27601151ee557c8a9e&v=4")
anyelle.photo.attach(io: anyelleAvatar, filename: 'anyelle.png', content_type: 'image/png')

parikaya = User.create!(email: "parikaya@email.com", password: "password", first_name: "Parikaya", last_name: "Nanda",
                        phone_number: Faker::PhoneNumber.phone_number_with_country_code)
parikayaAvatar = URI.open("https://avatars.githubusercontent.com/u/166150062?s=400&u=bf92ac6d878719e89e490376532fc7d73a19b967&v=4")
parikaya.photo.attach(io: parikayaAvatar, filename: 'anyelle.png', content_type: 'image/png')

marie = User.create!(email: "marie@email.com", password: "password", first_name: "Marie", last_name: "Auer",
                     phone_number: Faker::PhoneNumber.phone_number_with_country_code)
marieAvatar = URI.open("https://avatars.githubusercontent.com/u/167030565?s=400&u=ac460e66b84b3adfc047d64714cde1fbcf7463f4&v=4")
marie.photo.attach(io: marieAvatar, filename: 'anyelle.png', content_type: 'image/png')

matilda = User.create!(email: "matilda@email.com", password: "password", first_name: "Matilda", last_name: "Fritzmeier",
                       phone_number: Faker::PhoneNumber.phone_number_with_country_code)
matildaAvatar = URI.open("https://avatars.githubusercontent.com/u/166733901?s=400&u=96579e32cc1e6c5615f395f2a9742649aa869c92&v=4")
matilda.photo.attach(io: matildaAvatar, filename: 'anyelle.png', content_type: 'image/png')

puts "Creating drivers..."

driverAnyelle = Driver.create!(user: anyelle, car_model: "Tesla Model 3", car_color: "black", car_plate: "1234ABC",
                               dl_number: "1234567890")
fileAnyelle = URI.open("https://source.unsplash.com/random/?car+#{driverAnyelle.car_model}")
driverAnyelle.photo.attach(io: fileAnyelle, filename: "#{driverAnyelle.car_model}.png", content_type: 'image/png')

driverParikaya = Driver.create!(user: parikaya, car_model: "Tesla Model S", car_color: "white", car_plate: "5678DEF",
                                dl_number: "0987654321")
fileParikaya = URI.open("https://source.unsplash.com/random/?car+#{driverParikaya.car_model}")
driverParikaya.photo.attach(io: fileParikaya, filename: "#{driverParikaya.car_model}.png", content_type: 'image/png')

driverMarie = Driver.create!(user: marie, car_model: "Tesla Model X", car_color: "blue", car_plate: "9012GHI",
                             dl_number: "5432167890")
fileMarie = URI.open("https://source.unsplash.com/random/?car+#{driverMarie.car_model}")
driverMarie.photo.attach(io: fileMarie, filename: "#{driverMarie.car_model}.png", content_type: 'image/png')

driverMatilda = Driver.create!(user: matilda, car_model: "Tesla Model Y", car_color: "red", car_plate: "3456JKL",
                               dl_number: "6789054321")
fileMatilda = URI.open("https://source.unsplash.com/random/?car+#{driverMatilda.car_model}")
driverMatilda.photo.attach(io: fileMatilda, filename: "#{driverMatilda.car_model}.png", content_type: 'image/png')

puts "Creating rides..."

ride1 = Ride.create!(origin: "Amsterdam", destination: "Sassenheim", date: Date.new(2024, 6, 15), start_time: "12:00",
                     remarks: "No smoking allowed", price_per_km: 0.5, seats: 3, driver: driverAnyelle)
ride2 = Ride.create!(origin: "Arnhem", destination: "Amsterdam", date: Date.new(2024, 6, 29), start_time: "14:00",
                     remarks: "No pets allowed", price_per_km: 0.6, seats: 2, driver: driverParikaya)
ride3 = Ride.create!(origin: "Rotterdam", destination: "Delft", date: Date.new(2024, 6, 20), start_time: "10:00",
                     remarks: "No food allowed", price_per_km: 0.7, seats: 4, driver: driverMarie)
ride4 = Ride.create!(origin: "Utrecht", destination: "Rotterdam", date: Date.new(2024, 6, 19), start_time: "16:00",
                     remarks: "No loud music allowed", price_per_km: 0.8, seats: 1, driver: driverMatilda)

ride5 = Ride.create!(origin: "Utrecht", destination: "Rotterdam", date: Date.new(2024, 5, 5), start_time: "16:00",
                     remarks: "No loud music allowed", price_per_km: 0.8, seats: 1, driver: driverMatilda)


puts "Creating bookings..."
booking1 = Booking.create!(ride: ride1, user: parikaya, seats: 2, status: "confirmed")
booking2 = Booking.create!(ride: ride2, user: marie, seats: 1, status: "pending")
Booking.create!(ride: ride2, user: marie, seats: 1, status: "confirmed")
Booking.create!(ride: ride5, user: marie, seats: 1, status: "confirmed")
Booking.create!(ride: ride4, user: marie, seats: 1, status: "confirmed")
Booking.create!(ride: ride2, user: marie, seats: 1, status: "confirmed")
Booking.create!(ride: ride1, user: marie, seats: 1, status: "confirmed")
Booking.create!(ride: ride5, user: marie, seats: 1, status: "confirmed")

booking3 = Booking.create!(ride: ride3, user: matilda, seats: 3, status: "confirmed")
booking4 = Booking.create!(ride: ride4, user: anyelle, seats: 1, status: "declined")

puts "Creating reviews..."
review1 = Review.create!(comments: "Great driver!", rating: 5, ride: ride1, reviewer: parikaya, receiver: anyelle)
review2 = Review.create!(comments: "Nice car!", rating: 4, ride: ride2, reviewer: marie, receiver: parikaya)
review3 = Review.create!(comments: "Good ride!", rating: 3, ride: ride3, reviewer: matilda, receiver: marie)
review4 = Review.create!(comments: "Bad experience!", rating: 2, ride: ride4, reviewer: anyelle, receiver: matilda)
review5 = Review.create!(comments: "Amazing driver!", rating: 1, ride: ride1, reviewer: anyelle, receiver: parikaya)
review6 = Review.create!(comments: "Horrible car!", rating: 1, ride: ride2, reviewer: parikaya, receiver: marie)
review7 = Review.create!(comments: "Awful ride!", rating: 1, ride: ride3, reviewer: marie, receiver: matilda)
review8 = Review.create!(comments: "Worst experience!", rating: 1, ride: ride4, reviewer: matilda, receiver: anyelle)
