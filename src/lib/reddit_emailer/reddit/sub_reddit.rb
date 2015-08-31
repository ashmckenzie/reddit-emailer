require 'json'
require 'rest-client'
require 'hashie'

require 'reddit_emailer/reddit/sub_reddit/post'

module RedditEmailer
  module Reddit
    class SubReddit

      attr_reader :name, :maximum

      def initialize(name, maximum, validations={})
        @name = name
        @maximum = maximum
        @validations = validations
      end

      def posts
        posts = []

        response.data.children.each do |p|
          post = Post.new(p)
          post_validation = PostValidator.new(post, validations)

          if post_validation.valid?
            posts << post
          else
            $logger.debug "Not including post %s as it's invalid - %s" % [ post.url, post_validation.messages ]
          end

          break if posts.count >= maximum
        end

        posts
      end

      private

        attr_reader :validations

        def url
          base_url % { subreddit: name }
        end

        def base_url
          ENV['REDDIT_BASE_URL']
        end

        def response
          Hashie::Mash.new(fetch)
        end

        def fetch
          headers = { 'Cache-Control' => 'no-cache' }
          JSON.parse(RestClient.get(url, headers))
        end
    end
  end
end
