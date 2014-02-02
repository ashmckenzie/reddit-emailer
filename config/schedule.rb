require File.expand_path(File.join('..', 'initialise'), __FILE__)

def config
  RedditEmailer::Config.instance
end

set :base, "#{ENV['HOME']}/apps/#{config.name}"
set :output, "#{base}/log/cron.log"

config.email.to.each do |x|
  run_at, emails = x
  run_at = run_at.gsub(/_/, ':')

  set :cmd, "cd #{base} && \
  ERRBIT_ENABLE=true APP_ENV=production bundle exec ./bin/reddit-emailer \
  --subreddit #{config.reddit.subreddit} \
  --emails \"#{emails}\""

  send(:every, 1.day, at: run_at) do
    command cmd
  end
end
