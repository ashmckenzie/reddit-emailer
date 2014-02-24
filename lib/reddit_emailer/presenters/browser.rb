# coding: utf-8

require 'tempfile'

module RedditEmailer
  module Presenters
    class Browser

      def initialize subreddit
        @subreddit = subreddit
      end

      def display!
        filename = Tempfile.new(['reddit-emailer', '.html'])
        File.open(filename, 'w') { |f| f.write(html.content) }
        `open #{filename.path}`
        sleep(2)
      end

      private

        attr_reader :subreddit

        def html
          Generators::Html.new(subreddit)
        end
    end
  end
end
