require "bundler/capistrano"
require 'rvm/capistrano'

set :application, 'znc_log_viewer'
set :scm, :git
set :repository,  "git@bitbucket.org:ghedamat/znc_log_viewer.git"
set :branch, 'testcap'
set :domain,      'emberlogs.ghedamat.com'
set :environment, 'production'
server 'emberlogs.ghedamat.com', :web, :app, :db, primary: true
set :deploy_to, "/home/deploy/#{application}"



#set :scm_user, 'ghedamat'
set :user, 'deploy'
set :copy_exclude, [".git"]

set :use_sudo, false
ssh_options[:forward_agent] = true

set :rvm_type, :user
set :rvm_ruby_string, 'default'


# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

#role :web, "your web-server here"                          # Your HTTP server, Apache/etc
#role :app, "your app-server here"                          # This may be the same as your `Web` server
#role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

#role "emberlogs.ghedamat.com", :app, :web, :db, :primary => true

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
#

# env
#set :bundle_flags, "--deployment --no-prune --quiet"

# assets
set :normalize_asset_timestamps, false

#after "deploy:setup", :create_required_shared_dirs
#task :create_required_shared_dirs, :roles => :app do
#  run "mkdir -p #{shared_path}/config"
#end

#after "deploy:update_code", :link_shared_resources
#task :link_shared_resources, :roles => :app do
#  run "ln -nfs #{shared_path}/config/*.yml #{release_path}/config/"
#end
namespace :deploy do
task :symlink_config, roles: :app do
  run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
end
after "deploy:finalize_update", "deploy:symlink_config"
end

# process management
namespace :deploy do
  desc "custom *graceful* restart task for unicorn via init.d script"
  task :restart, :except => { :no_release => true } do
    sudo "/etc/init.d/unicorn upgrade"
  end

  task :log do
    stream "tail -n 2000 -f #{current_path}/log/#{environment}.log"
  end
end

