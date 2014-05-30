# coding: utf-8

require 'uri'

module RedditEmailer
  class ImageFactory

    def initialize url
      @url = url
    end

    def processor
      if is_plain?
        ImageProcessors::Plain.new(url)
      elsif is_imgur?
        ImageProcessors::Imgur.new(url)
      else
        binding.pry
        raise UnknownURL, 'Unknown URL %s' % [ url ]
      end
    end

    private

      attr_reader :url

      def is_plain?
        url.match(/\.(jpg|jpeg|gif|png)$/i)
      end

      def is_imgur?
        [ ImageProcessors::Imgur::IMGUR_DOMAIN, ImageProcessors::Imgur::IMGUR_IMAGE_DOMAIN ].include?(URI.parse(url).hostname)
      end
  end
end
