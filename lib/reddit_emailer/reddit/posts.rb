# coding: utf-8

module RedditEmailer
  module Reddit
    class Posts

      def initialize subreddit, maximum, options
        @subreddit = subreddit
        @maximum = maximum
        @options = options
      end

      def fetch filter={}
        posts = []

        SubReddit.new(subreddit).posts.each do |p|
          post = Post.new(p)
          post_filter = PostFilter.new(post, filter)

          if post_filter.valid?
            posts << post
          else
            $logger.debug "Not including post as it's invalid - #{post_filter.messages}"
          end

          break if posts.count >= maximum
        end

        posts
      end

      private

        attr_reader :subreddit, :maximum, :options

    end
  end
end
