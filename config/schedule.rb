Dir[File.join('config', 'initialisers', '*.rb')].sort.each { |f| require "./#{f}" }

set :base, "#{ENV['HOME']}/#{$APP_CONFIG.name}/current"
set :output, "#{base}/log/cron.log"

set :cmd, "cd #{base} && \
ERRBIT_ENABLE=true APP_ENV=production ./scripts/reddit-emailer \
--limit #{$APP_CONFIG.reddit.default_limit} \
--subreddit #{$APP_CONFIG.reddit.subreddit} \
--email \"#{$APP_CONFIG.email.to}\""

send(:every, eval($APP_CONFIG.cron.frequency), eval("{ #{$APP_CONFIG.cron.options} }")) do
  command cmd
end