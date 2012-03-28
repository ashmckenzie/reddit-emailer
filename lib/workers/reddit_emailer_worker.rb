class RedditEmailerWorker

  # extend Resque::Plugins::Retry

  @queue = :reddit_emailer

  # @retry_limit = 3
  # @retry_delay = 10

  def self.perform opts
    RedditEmailer.new(opts['subreddit'], opts['limit'], opts['email'])
  end
end