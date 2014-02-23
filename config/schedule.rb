require 'pry'
require File.expand_path(File.join('..', 'initialise'), __FILE__)

set :config, RedditEmailer::Config.instance
set :base, "#{config.deploy.base}"
set :output, "#{base}/log/cron.log"

env :PATH, "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

config.email.to.each do |x|

  command = %Q{cd #{base} && \
   ERRBIT_ENABLE="true" APP_ENV="production" /usr/local/bin/bundle exec ./bin/reddit-emailer \
   --maximum #{x.maximum} \
   #{x.options} \
   --subreddit #{config.reddit.subreddit} \
   --emails "#{x.recipients}"}

  set :cmd, command

  send(:every, 1.day, at: x.time) do
    command cmd
  end
end
