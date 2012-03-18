require 'yaml'

CONFIG = YAML.load_file('config/config.yml')

set :base, "#{ENV['HOME']}/#{CONFIG['app']['name']}/current"
set :output, "#{base}/log/cron.log"

send(:every, eval(CONFIG['app']['cron']['frequency']), eval("{ #{CONFIG['app']['cron']['options']} }")) do
  command "cd #{base} && ./reddit-emailer --limit #{CONFIG['app']['reddit']['limit']} --subreddit #{CONFIG['app']['subreddit']} --email \"#{CONFIG['app']['email']['to']}\""
end
