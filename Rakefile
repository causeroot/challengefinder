#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

ChallengeFinder::Application.load_tasks

task :exportjs => :environment do
#  ActiveRecord::Base.include_root_in_json = true
  file = File.open('data.json', 'w')
  file.write("{\n\"challenges\": #{Challenge.all.to_json},\n")
  file.write("\n\"awards\": #{Award.all.to_json},\n")
  file.write("\n\"deadlines\": #{Deadline.all.to_json}\n")
  file.write("\n}")
end
