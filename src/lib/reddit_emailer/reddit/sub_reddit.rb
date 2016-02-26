require 'json'
require 'rest-client'
require 'hashie'

require 'reddit_emailer/reddit/sub_reddit/post'

module RedditEmailer
  module Reddit
    class SubReddit

      def initialize(options)
        @options = options
      end

      def name
        options[:name]
      end

      def label
        options[:label]
      end

      def maximum
        options[:maximum]
      end

      def posts
        raw.each_with_object([]) do |p, all|
          post = Post.new(p)
          post_validation = PostValidator.new(post, validations)
          if post_validation.valid?
            all << post
            break if all.count >= maximum
          else
            $logger.debug "Not including post %s as it's invalid - %s" % [ post.url, post_validation.messages ]
          end
        end
      end

      private

        attr_reader :options

        def validations
          options[:exclude]
        end

        def url
          base_url % [ name ]
        end

        def base_url
          '%s/r/%%s.json' % [ ENV['REDDIT_BASE_URL'] ]
        end

        def raw
          @raw ||= response.data.children
        end

        def response
          Hashie::Mash.new(fetch)
        end

        def fetch
          JSON.parse(RestClient.get(url, 'Cache-Control' => 'no-cache'))
        end
    end
  end
end
