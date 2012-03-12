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

set :user, CONFIG['deploy']['ssh_user']
ssh_options[:port] = CONFIG['deploy']['ssh_port']
ssh_options[:keys] = eval(CONFIG['deploy']['ssh_key'])

role :app, CONFIG['deploy']['ssh_host']

after "deploy:update", "deploy:cleanup"
