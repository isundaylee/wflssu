# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Su::Application.initialize!

config_file_path = File.join(Rails.root, "config/config.yml")

APP_CONFIG = YAML.load_file(config_file_path) if File.exists?(config_file_path)