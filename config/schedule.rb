require File.expand_path(File.join('..', 'initialise'), __FILE__)

set :config, RedditEmailer::Config.instance
set :base, "#{config.deploy.base}"
set :output, "#{base}/log/cron.log"

env :PATH, "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

config.email.to.each do |x|

  recipients = x.recipients.join(', ')

  set :cmd, %Q{cd #{base} && \
    APP_ENV="production" /usr/local/bin/bundle exec ./bin/reddit-emailer \
    --maximum #{x.maximum} \
    --subreddit #{config.reddit.subreddit} \
    #{x.options} \
    --emails "#{recipients}"}

  send(:every, 1.day, at: x.time) { command(cmd) }
end
