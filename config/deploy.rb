require 'yaml'
require 'capistrano_colors'

set :bundle_cmd, '. /etc/profile && bundle'
require "bundler/capistrano"

require File.expand_path(File.join('config', 'initialisers', '00_config'))

set :application, "Reddit Emailer"
set :repository, $CONFIG.deploy.repo

set :scm, :git
set :scm_verbose, true

set :deploy_to, "#{$CONFIG.deploy.base}/#{$APP_CONFIG.name}"
set :deploy_via, :remote_cache

set :keep_releases, 3
set :use_sudo, false
set :normalize_asset_timestamps, false

set :user, $CONFIG.deploy.ssh_user
ssh_options[:port] = $CONFIG.deploy.ssh_port
ssh_options[:keys] = eval($CONFIG.deploy.ssh_key)
ssh_options[:forward_agent] = true

role :app, $CONFIG.deploy.ssh_host

after "deploy:update", "deploy:cleanup"
after "deploy:setup", "deploy:more_setup"

before "deploy:create_symlink", "deploy:configs"

namespace :deploy do

  desc 'More setup.. ensure necessary directories exist, etc'
  task :more_setup do
    run "mkdir -p #{shared_path}/config #{shared_path}/log"
  end

  desc 'Deploy necessary configs into shared/config'
  task :configs do
    put CONFIG.reject { |x| [ 'deploy' ].include?(x) }.to_yaml, "#{shared_path}/config/config.yml"
    run "ln -nfs #{shared_path}/config/config.yml #{release_path}/config/config.yml"
  end
end