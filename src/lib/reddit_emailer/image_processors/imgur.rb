require 'uri'
require 'rest-client'
require 'nokogiri'

module RedditEmailer
  module ImageProcessors
    class Imgur

      IMGUR_DOMAIN = 'imgur.com'
      IMGUR_IMAGE_DOMAIN = 'i.imgur.com'
      IMGR_API_BASE_URL = 'http://api.imgur.com/2'

      def initialize(url)
        @url = url
      end

      def images
        extract_images
      rescue => e
        $logger.error "An exception occurred: #{e.inspect}"
        []
      end

      private

        attr_reader :url

        def api_url
          m = url.match(%r{^http://.*imgur\.com/(?:\b(a|album|gallery)(?:/)\b)?(\w+)})

          if m
            api_url = IMGR_API_BASE_URL
            api_url += m[1] ? "/album/#{m[2]}" : "/image/#{m[2]}"
            "#{api_url}.xml"
          else
            fail CannotDetermineURL, 'Cannot determine API URL for %s' % [ url ]
          end
        end

        def max_images
          ENV.fetch('REDDIT_MAX_ALBUM_IMAGES', 10).to_i
        end

        def extract_images
          links.first(max_images)
        end

        def links
          Nokogiri::XML(RestClient.get(api_url)).search('links/original').map(&:text)
        end
    end
  end
end
