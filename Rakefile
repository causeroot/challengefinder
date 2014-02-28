#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

ChallengeFinder::Application.load_tasks

task :exportjs => :environment do
#  ActiveRecord::Base.include_root_in_json = true
  file = File.open('data.json', 'w')
  file.write("#{Challenge.all.to_json(include: [{ :awards => { :except => [:created_at, :updated_at, :challenge_id, :id]}}, { :deadlines => { :except => [:created_at, :updated_at, :challenge_id, :id]}}])}\n")
end

