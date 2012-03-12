require 'yaml'
require 'pry'

CONFIG = YAML.load_file('config/config.yml')

set :base, "#{CONFIG['base_location']}/current"
set :output, "#{base}/log/cron.log"

send(:every, eval(CONFIG['app']['cron']['frequency']), eval("{ #{CONFIG['app']['cron']['options']} }")) do
  command "cd #{base} && ./reddit-emailer --limit #{CONFIG['app']['limit']} --subreddit #{CONFIG['app']['subreddit']} --email \"#{CONFIG['app']['emails']}\""
end
