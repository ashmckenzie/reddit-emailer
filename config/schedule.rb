require File.expand_path(File.join('..', 'initialise'), __FILE__)

set :config, RedditEmailer::Config.instance
set :base, "#{config.deploy.base}"
set :output, "#{base}/log/cron.log"

env :PATH, "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

config.subreddits.each do |subreddit|
  subreddit.schedule.each do |schedule|
    recipients = schedule.recipients.join(', ')

    set :cmd, %Q{cd #{base} && \
      /usr/local/bin/bundle exec ./bin/reddit-emailer \
      --maximum #{schedule.maximum} \
      --subreddit "#{subreddit.name}" \
      --title-filter-exclude "#{schedule.exclude}" \
      --emails "#{recipients}"}

    send(:every, 1.day, at: schedule.time) { command(cmd) }
  end
end
