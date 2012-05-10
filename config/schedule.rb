require 'yaml'

CONFIG = YAML.load_file('config/config.yml')

set :base, "#{ENV['HOME']}/#{CONFIG['app']['name']}/current"
set :output, "#{base}/log/cron.log"

send(:every, eval(CONFIG['app']['cron']['frequency']), eval("{ #{CONFIG['app']['cron']['options']} }")) do
  command "cd #{base} &&  REDDIT_EMAILER_ERRBIT_ENABLE=true REDDIT_EMAILER_ENV=production ./scripts/reddit-emailer --limit #{CONFIG['app']['reddit']['limit']} --subreddit #{CONFIG['app']['reddit']['subreddit']} --email \"#{CONFIG['app']['email']['to']}\""
end
