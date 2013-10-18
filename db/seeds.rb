# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#challenges = YAML::load_file('db/challenge_star.yml')
#challenges.each {|key, value| Challenge.create(value) }

json = ActiveSupport::JSON.decode(File.read('db/challenges.json'))

json.each do |a|
  if Challenge.find_by_title(a["title"]).nil?
    puts "Adding " + a["title"]
    Challenge.create(a, :without_protection => true)
  end
end

if User.find_by_username("admin").nil?
  User.create! do |u|
    puts "Adding admin user."
    u.username = 'admin'
    u.email = 'info@causeroot.org'
    u.password = 'password'
    u.password_confirmation = 'password'
  end
end