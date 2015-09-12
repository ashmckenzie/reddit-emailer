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
        '%s for %s' % [ title_template, now ]
      end

      private

        attr_reader :subreddit

        def title_template
          "Top %s Reddit '%s' pics" % [ subreddit.maximum, subreddit.label ]
        end

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
