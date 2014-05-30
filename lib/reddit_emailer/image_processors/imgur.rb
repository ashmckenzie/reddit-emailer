# coding: utf-8

require 'uri'
require 'rest-client'
require 'nokogiri'

module RedditEmailer
  module ImageProcessors
    class Imgur

      IMGUR_DOMAIN = 'imgur.com'
      IMGUR_IMAGE_DOMAIN = 'i.imgur.com'
      IMGR_API_BASE_URL = 'http://api.imgur.com/2'

      def initialize url
        @url = url
      end

      def images
        extract_images
      rescue SocketError => e
        $logger.error "An exception occurred: #{e.inspect}"
        raise e
      end

      private

        attr_reader :url

        def config
          RedditEmailer::Config.instance
        end

        def api_url
          if m = url.match(/^http:\/\/.*imgur\.com\/(a)?\/?(\w+)/)
            api_url = IMGR_API_BASE_URL
            api_url += (m[1] == 'a') ? "/album/#{m[2]}" : "/image/#{m[2]}"
            "#{api_url}.xml"
          else
            raise CannotDetermineURL, 'Cannot determine API URL for %s' % [ url ]
          end
        end

        def extract_images
          Nokogiri::XML(RestClient.get(api_url)).search('links/original').map { |links| links.text }.first(config.reddit.max_album_images)
        end
    end
  end
end
