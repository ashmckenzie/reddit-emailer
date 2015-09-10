module RedditEmailer
  module Reddit
    class SubReddit
      class Post

        attr_accessor :errors

        def initialize(json)
          @data = json.data
        end

        def url
          data.url.gsub(/#.+$/, '')
        end

        def title
          data.title.to_s
        end

        def image_urls
          RedditEmailer::ImageFactory.new(url).processor.images.map { |url| full_url_from(url) }
        rescue RedditEmailer::UnknownURL, RedditEmailer::CannotDetermineURL
          []
        end

        private

          attr_reader :data

          def image_scaler_url
            ENV['IMAGE_PROXY_URL']
          end

          def image_scaler_dimensions
            ENV['IMAGE_PROXY_DIMENSIONS']
          end

          def full_url_from(url)
            '%s/%s/%s' % [ image_scaler_url, image_scaler_dimensions, CGI.escape(url) ]
          end
      end
    end
  end
end
