require_relative '../../lib/reddit_emailer/config'
require 'rollbar'

Rollbar.configure do |config|
  config.environment = 'production' 
  config.access_token = RedditEmailer::Config.instance.rollbar.api_key
end
