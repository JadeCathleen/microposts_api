# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require "faker"

if Rails.env.development?
  puts "Destroying microposts in DB"
  Micropost.destroy_all

  puts "Seeding development data..."

  10.times do |i|
    Micropost.create!(title: Faker::Games::Pokemon.name, body: Faker::Games::Pokemon.move)
  end

  puts "#{Micropost.count} Microposts created"
end
