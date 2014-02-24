# coding: utf-8

require 'thread'
require 'thwait'
require 'inline-style'
require 'slim'

module RedditEmailer
  module Generators
    class Html

      def initialize subreddit
        @subreddit = subreddit
      end

      def content
        InlineStyle.process(html)
      end

      def title
        @title ||= begin
          title = "Top %{maximum} Reddit '%{subreddit}' images" % { maximum: subreddit.maximum, subreddit: subreddit.name }
          now = Time.now.strftime('%A %d %B %Y')

          "%{title} for %{now}" % { title: title, now: now }
        end
      end

      private

        attr_reader :subreddit

        def html
          content = Hashie::Mash.new({ body: body, title: title })
          Slim::Template.new('./lib/templates/layout.html.slim').render(content)
        end

        def body
          jobs = []
          body = {}

          subreddit.posts.each_with_index do |post, i|
            jobs << Thread.new {
              content = Hashie::Mash.new({ post: post })
              body[i + 1] = Slim::Template.new('./lib/templates/shared/_post.html.slim').render(content)
            }
          end

          ThreadsWait.all_waits(*jobs)

          body.sort.map { |x, y| y }.join("\n")
        end
    end
  end
end
