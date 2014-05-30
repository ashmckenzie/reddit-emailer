# coding: utf-8

require 'uri'
require 'rest-client'
require 'nokogiri'

module RedditEmailer
  class ImgurUrl

    IMGUR_IMAGE_DOMAIN = 'i.imgur.com'
    IMGR_API_BASE_URL = 'http://api.imgur.com/2'

    def initialize url
      @url = url
    end

    def images
      if url_is_valid_image?(url)
        [ url ]
      else
        begin
          extract_images
        rescue SocketError => e
          $logger.error "An exception occurred: #{e.inspect}"
          []
        end
      end
    end

    private

      attr_reader :url

      def config
        RedditEmailer::Config.instance
      end

      def url_is_valid_image? url
        URI.parse(url).hostname == IMGUR_IMAGE_DOMAIN && url.match(/\.(jpg|jpeg|gif|png)$/i)
      end

      # FIXME
      def api_url
        if m = url.match(/^http:\/\/.*imgur\.com\/(a)?\/?(\w+)/)
          api_url = IMGR_API_BASE_URL
          api_url += (m[1] == 'a') ? "/album/#{m[2]}" : "/image/#{m[2]}"
          "#{api_url}.xml"
        else
          nil
        end
      end

      def extract_images
        begin
          Nokogiri::XML(RestClient.get(api_url)).search('links/original').collect { |x| x.text }.first(config.reddit.max_album_images)
        rescue => e
          $logger.error "An exception occurred: #{e.inspect}"
          []
        end
      end
  end
end
