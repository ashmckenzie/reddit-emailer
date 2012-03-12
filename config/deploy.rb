require "bundler/capistrano"
require "whenever/capistrano"

require 'yaml'

CONFIG = YAML.load_file('config/config.yml')

set :application, "Reddit Emailer"
set :repository, CONFIG['deploy']['repo']

set :scm, :git
set :deploy_to, CONFIG['deploy']['location']
set :deploy_via, :copy
set :keep_releases, 3
set :use_sudo, false

set :bundle_cmd, '. /etc/profile && bundle'
set :whenever_command, "bundle exec whenever"

set :user, CONFIG['deploy']['ssh_user']
ssh_options[:port] = CONFIG['deploy']['ssh_port']
ssh_options[:keys] = eval(CONFIG['deploy']['ssh_key'])

role :app, CONFIG['deploy']['ssh_host']

after "deploy:update", "deploy:cleanup"
after "deploy:setup", "deploy:more_setup"

before "deploy:create_symlink", "deploy:configs"

namespace :deploy do

  desc 'More setup.. ensure necessary directories exist, etc'
  task :more_setup do
    run "mkdir -p #{shared_path}/config"
  end

  desc 'Deploy necessary configs into shared/config'
  task :configs do
    put CONFIG.reject { |x| x == 'deploy' }.to_yaml, "#{shared_path}/config/config.yml"
    run "ln -nfs #{shared_path}/config/config.yml #{release_path}/config/config.yml"
  end
end
