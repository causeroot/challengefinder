source 'https://rubygems.org'

gem 'rails', '~> 3.2.6'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'


gem 'sunspot_rails'
gem 'sunspot_solr'

gem 'sorcery'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.5'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platform => :ruby

  gem 'uglifier', '>= 1.0.3'
  gem 'twitter-bootstrap-rails'
end

gem 'jquery-rails'

gem 'kaminari'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :production do
  gem 'activerecord-mysql-adapter'
  gem 'mysql2'
end

group :development do
  gem 'guard'
  gem 'guard-cucumber'
  gem 'terminal-notifier-guard'	
end

group :test, :development do
  gem 'sqlite3'
  gem "brakeman"
  gem "rspec-rails", "~> 2.0"
  gem "factory_girl_rails", "~> 4.0"
  gem "faker"
end

group :test do
  gem 'cucumber-rails', :require => false
  gem "capybara"
  # database_cleaner is not required, but highly recommended
  gem 'database_cleaner'
  gem 'email_spec'
	gem 'simplecov', :require => false
	gem 'simplecov-rcov', :require => false
end

