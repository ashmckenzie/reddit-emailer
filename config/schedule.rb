def config
  RedditEmailer::Config.instance
end

set :base, "#{ENV['HOME']}/#{config.name}/current"
set :output, "#{base}/log/cron.log"

set :cmd, "cd #{base} && \
ERRBIT_ENABLE=true APP_ENV=production ./scripts/reddit-emailer \
--limit #{config.reddit.default_limit} \
--subreddit #{config.reddit.subreddit} \
--email \"#{config.email.to}\""

send(:every, eval(config.cron.frequency), eval("{ #{config.cron.options} }")) do
  command cmd
end
