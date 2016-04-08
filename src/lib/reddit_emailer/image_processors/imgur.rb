require 'reddit_emailer/image_processors/imgur/main'
require 'reddit_emailer/image_processors/imgur/base'
require 'reddit_emailer/image_processors/imgur/image'
require 'reddit_emailer/image_processors/imgur/album'

module RedditEmailer
  module ImageProcessors
    module Imgur
      DOMAIN = 'imgur.com'.freeze
      IMAGE_DOMAIN = 'i.imgur.com'.freeze
      API_BASE_URL = 'https://api.imgur.com/3'.freeze
      URL_REGEX = %r{^http(?:s?)://.*imgur\.com/(?:\b(?<type>a|album|gallery)(?:/)\b)?(?<path>\w+)}
    end
  end
end
