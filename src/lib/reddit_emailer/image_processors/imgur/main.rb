require 'uri'
require 'rest-client'

module RedditEmailer
  module ImageProcessors
    module Imgur
      class Main
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

          def max_images
            ENV.fetch('REDDIT_MAX_ALBUM_IMAGES', 10).to_i
          end

          def extract_images
            links.first(max_images)
          end

          def api_url_klass
            match = url.match(URL_REGEX)
            case match['type'].to_s.downcase
            when 'a', 'album'
              Album
            when 'g', 'gallery'
              nil
            else
              Image
            end
          end

          def links
            @links ||= api_url_klass ? api_url_klass.new(url).links : []
          end
      end
    end
  end
end
