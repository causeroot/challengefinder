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
  Challenge.create(a, :without_protection => true)
#  Challenge.where(a).first_or_create
end

User.create! do |u|
  u.username = 'admin'
  u.email = 'info@causeroot.org'
  u.password = 'password'
  u.password_confirmation = 'password'
end
