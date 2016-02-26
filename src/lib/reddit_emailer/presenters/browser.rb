require 'tempfile'

module RedditEmailer
  module Presenters
    class Browser

      def initialize(sub_reddits)
        @sub_reddits = sub_reddits
      end

      def display!
        File.open(filename, 'w') { |f| f.write(html.content) }
        `open #{filename.path}`
        sleep(2) # so the browser has enough time to render before it's removed
      end

      private

        attr_reader :sub_reddits

        def html
          Generators::HTML.new(sub_reddits)
        end

        def filename
          @filename ||= Tempfile.new(['reddit-emailer', '.html'])
        end
    end
  end
end
