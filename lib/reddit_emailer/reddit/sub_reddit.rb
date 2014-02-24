# coding: utf-8

require 'json'
require 'rest-client'
require 'hashie'

module RedditEmailer
  module Reddit
    class SubReddit

      attr_reader :name, :maximum

      def initialize name, maximum, validations={}
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
            $logger.debug "Not including post as it's invalid - #{post_validation.messages}"
          end

          break if posts.count >= maximum
        end

        posts
      end

      private

        attr_reader :validations

        def url
          RedditEmailer::Config.instance.reddit.url % { subreddit: name }
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
