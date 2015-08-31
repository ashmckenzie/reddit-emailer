require 'tempfile'

module RedditEmailer
  module Presenters
    class Browser

      def initialize(subreddit)
        @subreddit = subreddit
      end

      def display!
        File.open(filename, 'w') { |f| f.write(html.content) }
        `open #{filename.path}`
        sleep(2) # so the browser has enough time to render before it's removed
      end

      private

        attr_reader :subreddit

        def html
          Generators::HTML.new(subreddit)
        end

        def filename
          @filename ||= Tempfile.new(['reddit-emailer', '.html'])
        end
    end
  end
end
