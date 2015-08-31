require 'inline-style'
require 'slim'
require 'thread'

module RedditEmailer
  module Generators
    class HTML

      def initialize(subreddit)
        @subreddit = subreddit
      end

      def content
        InlineStyle.process(html)
      end

      def title
        title = "Top %s Reddit '%s' images" % [ subreddit.maximum, subreddit.name ]
        '%s for %s' % [ title, now ]
      end

      private

        attr_reader :subreddit

        def html
          attrs = Hashie::Mash.new(body: body, title: title)
          Slim::Template.new('./lib/templates/layout.html.slim').render(attrs)
        end

        def now
          Time.now.strftime('%A %d %B %Y')
        end

        def body
          @body ||= Thread.new { Jobs::PostRenderRunner.new(subreddit.posts).run }.join.value
        end
    end
  end
end
