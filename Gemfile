source 'https://rubygems.org'

gem 'rails', '3.2.8'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'

# Gems for markdown interpretation

gem 'redcarpet'
gem 'coderay'

# Gems for member authentication

gem 'bcrypt-ruby', '~> 3.0.0'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'

  # Twitter Bootstrap
  
  gem 'twitter-bootstrap-rails', :git => 'git://github.com/seyhunak/twitter-bootstrap-rails'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
gem 'capistrano'

# To use debugger
# gem 'debugger'

group :development, :test do
  gem "rspec-rails", ">= 2.8.1"
  gem "factory_girl_rails", "~> 4.2.0"
  gem "guard-rspec", "~> 2.4.0"

  # rb-fsevent is guard-rspec dependency
  gem 'rb-fsevent', '~> 0.9'
end

group :test do
  gem "faker", "~> 1.1.2"
  gem "capybara", "~> 2.0.2"
  gem "database_cleaner", "~> 0.9.1"
  gem "launchy", "~> 2.2.0"
  gem "shoulda"
end

group :test do
end