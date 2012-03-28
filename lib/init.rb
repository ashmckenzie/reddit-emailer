require 'bundler/setup'
Bundler.require(:default, :development)

require_relative 'utils'
require_relative 'workers/reddit_emailer_worker'
require_relative 'reddit_emailer'

$CONFIG = YAML.load_file('config/config.yml')['app']

include Utils