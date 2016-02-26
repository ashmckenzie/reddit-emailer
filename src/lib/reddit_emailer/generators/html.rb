require 'inline-style'
require 'slim'
require 'thread'

module RedditEmailer
  module Generators
    class HTML

      def initialize(sub_reddits)
        @sub_reddits = sub_reddits
      end

      def content
        InlineStyle.process(html)
      end

      def title
        '%s for %s' % [ title_template, now ]
      end

      private

        attr_reader :sub_reddits

        def title_template
          "Reddit '%s' pics" % [ sub_reddits_label ]
        end

        def sub_reddits_label
          sub_reddits.map(&:label).join(', ')
        end

        def html
          Slim::Template.new('./lib/templates/layout.html.slim').render(layout_attrs)
        end

        def layout_attrs
          Hashie::Mash.new(body: body, title: title)
        end

        def now
          Time.now.strftime('%A %d %B %Y')
        end

        def sub_reddit_posts
          @sub_reddit_posts ||= sub_reddits.map(&:posts)
        end

        def body
          @body ||= begin
            sub_reddit_posts.map { |posts| Jobs::PostRenderRunner.new(posts).run }
          end
        end
    end
  end
end
