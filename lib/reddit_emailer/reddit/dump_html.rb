# coding: utf-8

require 'tempfile'

module RedditEmailer
  module Reddit
    class DumpHtml

      def initialize html, subreddit, options
        @html = html
        @subreddit = subreddit
        @options = options
      end

      def dump!
        filename = Tempfile.new(['reddit-emailer', '.html'])
        File.open(filename, 'w') { |f| f.write(html) }
        `open #{filename.path}`
        sleep(2)
      end

      private

        attr_reader :html, :subreddit, :options

        def config
          RedditEmailer::Config.instance
        end
    end
  end
end
