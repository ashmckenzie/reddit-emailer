require 'yaml'

CONFIG = YAML.load_file('config/config.yml')

set :base, "~/apps/reddit-emailer/current"
set :output, "#{base}/log/cron.log"

every 1.day, :at => '8:00 pm' do
  command "cd #{base} && ./reddit-emailer --limit #{CONFIG['app']['limit']} --subreddit #{CONFIG['app']['subreddit']} --email \"#{CONFIG['app']['emails']}\""
end
