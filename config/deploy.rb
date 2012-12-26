require 'bundler/capistrano'
load 'deploy/assets'

set :application, "wflssu"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/home/ubuntu/wflssu"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, :git
set :repository, "git@github.com:isundaylee/wflssu.git"
set :branch, "master"

set :user, 'ubuntu'
server "204.236.142.15", :app, :web, :db, :primary => true
ssh_options[:keys] = ["#{ENV['HOME']}/.ssh/lovenancy.pem"]
ssh_options[:forward_agent] = true

# Rails 3 support
set :normalize_asset_timestamps, false

# Don't use SUDO for initial setups
set :use_sudo, false

namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end

  after "deploy", "deploy:database_config_symlink"
  desc "Make symlink for database yaml" 
  task :database_config_symlink do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml" 
  end

  after "deploy", "deploy:symlink_database"
  desc "Link the production SQLite3 database. "
  task :symlink_database do 
    run "cd #{current_path}; ln -s #{shared_path}/db/production.sqlite3 #{release_path}/db/production.SQLite33"
  end

  desc "precompile the assets"
  task :precompile_assets, :roles => :web, :except => { :no_release => true } do
    run "cd #{current_path}; rm -rf public/assets/*"
    run "cd #{current_path}; RAILS_ENV=production bundle exec rake assets:precompile"
  end
end

after "deploy", "deploy:migrate"
