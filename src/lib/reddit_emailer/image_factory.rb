require 'uri'

require 'reddit_emailer/image_processors/plain'
require 'reddit_emailer/image_processors/imgur'

module RedditEmailer
  class ImageFactory

    def initialize(url)
      @url = url
    end

    def processor
      if plain?
        ImageProcessors::Plain.new(url)
      elsif imgur?
        ImageProcessors::Imgur.new(url)
      else
        fail UnknownURL, 'Unknown URL %s' % [ url ]
      end
    end

    private

      attr_reader :url

      def plain?
        url.match(/\.(jpg|jpeg|gif|png)$/i)
      end

      def imgur?
        [ ImageProcessors::Imgur::IMGUR_DOMAIN, ImageProcessors::Imgur::IMGUR_IMAGE_DOMAIN ].include?(URI.parse(url).hostname)
      end
  end
end
