# coding: utf-8

require 'json'
require 'rest-client'
require 'hashie'

module RedditEmailer
  module Reddit
    class SubReddit

      def initialize name
        @name = name
      end

      def posts
        response.data.children
      end

      private

        attr_reader :name

        def url
          @url ||= RedditEmailer::Config.instance.reddit.url % { subreddit: name }
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
