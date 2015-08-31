require 'logger'
require 'hashie'
require 'rollbar'

require 'reddit_emailer/errors'
require 'reddit_emailer/config'
require 'reddit_emailer/reddit'
require 'reddit_emailer/image_factory'
require 'reddit_emailer/presenters'
require 'reddit_emailer/generators'

module RedditEmailer
  VERSION = '0.1.0'
end
