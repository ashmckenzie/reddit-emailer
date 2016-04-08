require 'json'
require 'rest-client'
require 'hashie'

require 'reddit_emailer/reddit/sub_reddit/post'

module RedditEmailer
  module Reddit
    class SubReddit

      attr_reader :name, :label, :maximum

      def initialize(name, label, maximum, validations = {})
        @name = name
        @label = label
        @maximum = maximum
        @validations = validations
      end

      def posts
        raw_posts.each_with_object([]) do |raw_post, all|
          post = Post.new(raw_post)
          post_validator = PostValidator.new(post, validations)
          unless post_validator.valid?
            $logger.debug "Not including post %s as it's invalid - %s" % [ post.url, post_validator.messages ]
            next
          end
          all << post
          return all if all.count >= maximum
        end
      end

      private

        attr_reader :validations

        def url
          base_url % [ name ]
        end

        def base_url
          '%s/r/%%s.json' % [ ENV['REDDIT_BASE_URL'] ]
        end

        def response
          Hashie::Mash.new(fetch)
        end

        def headers
          { 'Cache-Control' => 'no-cache' }
        end

        def fetch
          JSON.parse(RestClient.get(url, headers))
        end

        def raw_posts
          response.data.children
        end
    end
  end
end
