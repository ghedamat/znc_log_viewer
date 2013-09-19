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

set :user, 'deploy'
set :copy_exclude, [".git"]

set :use_sudo, false
ssh_options[:forward_agent] = true

set :rvm_type, :user
set :rvm_ruby_string, 'default'

# assets
set :normalize_asset_timestamps, false

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

