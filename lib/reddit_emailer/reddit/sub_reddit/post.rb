# coding: utf-8

module RedditEmailer
  module Reddit
    class SubReddit
      class Post

        attr_accessor :errors

        def initialize json
          @data = json.data
        end

        def url
          data.url.gsub(/#.+$/, '')
        end

        def title
          data.title.to_s
        end

        def image_urls
          RedditEmailer::ImgurUrl.new(url).images.collect do |url|
            "%s/%s/%s?api_key=%s" % [ config.image_scaler.url, config.image_scaler.dimensions, CGI.escape(url), config.image_scaler.api_key ]
          end
        end

        private

          attr_reader :data

          def config
            RedditEmailer::Config.instance
          end
        end
      end
    end
  end
