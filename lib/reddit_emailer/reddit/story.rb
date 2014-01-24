# coding: utf-8

require 'celluloid'
require 'nokogiri'

module RedditEmailer
  module Reddit
    class Story

      include Celluloid

      IMGUR_IMAGE_DOMAIN = 'i.imgur.com'

      def initialize json
        @data = json.data
      end

      def domain
        @domain ||= data.domain
      end

      def url
        @url ||= prep_image_url(data.url)
      end

      def image_urls
        images = []

        if domain == IMGUR_IMAGE_DOMAIN && url.match(/\.(jpg|jpeg|gif|png)$/i)
          images = [ url ]
        else

          # Lets try and extract out the imgur.com image :)
          #
          images = []

          begin
            images = extract_images
          rescue SocketError => e
            false
          end
        end

        images.collect do |url|
          "#{config.image_scaler.url}/#{config.image_scaler.dimensions}/#{CGI.escape(url)}?api_key=#{config.image_scaler.api_key}"
        end
      end

      def title
        data.title.to_s
      end

      private

        attr_reader :data

        def config
          RedditEmailer::Config.instance
        end

        def extract_images
          img_url = 'http://api.imgur.com/2'
          m = url.match(/^http:\/\/imgur\.com\/(a)?\/?(\w+)/)

          return [] unless m

          if m[1] == 'a'
            img_url += "/album/#{m[2]}"
          else
            img_url += "/image/#{m[2]}"
          end

          img_url += '.xml'

          begin
            Nokogiri::XML(open(img_url)).search('links/original').collect { |x| x.text }[0...config.reddit.max_album_images]
          rescue => e
            puts "An exception occurred: #{e.inspect}"
            []
          end
        end

        def prep_image_url url
          url.gsub(/#.+$/, '')
        end
    end
  end
end
