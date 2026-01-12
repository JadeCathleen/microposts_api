STDOUT.sync = true

# Faker only in dev/test
begin
  require "faker"
rescue LoadError
  puts "Faker not available (likely production) — using fallback values."
end

puts "===> Seeding start"

# Create or update a stable admin user
admin = User.find_or_create_by!(email: "test@test.com") do |user|
  user.password = "password"
  user.username = "TestUser"
  user.admin = true
end

# Ensure attributes stay correct even if record already existed
admin.update!(
  username: "TestUser",
  admin: true
)

puts "===> Admin user ready: #{admin.email}"

# Seed a small set of microposts WITHOUT destroying prod data
# Create stable unique titles to keep it idempotent.
existing = Micropost.where(user: admin).count
target = 10

if existing < target
  (existing...target).each do |i|
    title =
      if defined?(Faker)
        "#{Faker::Games::Pokemon.name}-#{i}"
      else
        "Seed Micropost #{i}"
      end

    body =
      if defined?(Faker)
        Faker::Games::Pokemon.move
      else
        "This is seeded content #{i}"
      end

    Micropost.create!(
      title: title,
      body: body,
      user: admin
    )
  end
end

puts "===> Microposts for admin: #{Micropost.where(user: admin).count}"
puts "===> Seeding done"
