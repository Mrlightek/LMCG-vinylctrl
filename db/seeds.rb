# # ── db/seeds.rb ──────────────────────────────────────────────────

puts "🎵 Seeding VinylCTRL..."

# Sample users
[
  { first_name: "Marcus", last_name: "Webb",    email_address: "marcus@vinylctrl.test",  user_type: "dj",       city: "Atlanta",  state: "GA" },
  { first_name: "Kezia",  last_name: "Amara",   email_address: "kezia@vinylctrl.test",   user_type: "artist",   city: "Miami",    state: "FL" },
  { first_name: "Maya",   last_name: "Torres",  email_address: "maya@vinylctrl.test",    user_type: "venue",    city: "Miami",    state: "FL" },
  { first_name: "Devon",  last_name: "Charles", email_address: "devon@vinylctrl.test",   user_type: "organizer",city: "Houston",  state: "TX" },
  { first_name: "Nova",   last_name: "Sound",   email_address: "nova@vinylctrl.test",    user_type: "dj",       city: "New York", state: "NY" },
].each do |attrs|
  user = User.find_or_create_by(email_address: attrs[:email]) do |u|
    u.assign_attributes(attrs.merge(password: "password123", password_confirmation: "password123"))
  end
  user.profile&.update!(
    published:   true,
    available:   true,
    hourly_rate: [300, 350, 400, 500, 600].sample,
    genres:      Profile::GENRES.sample(3),
    bio:         "Professional #{attrs[:user_type]} based in #{attrs[:city]}, #{attrs[:state]}.",
    tagline:     "Let the music speak."
  )
  print "."
end

puts "\n✅ #{User.count} users seeded."
puts "🎵 VinylCTRL is ready to CTRL!"