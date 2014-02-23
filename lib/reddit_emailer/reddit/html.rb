# coding: utf-8

require 'inline-style'
require 'slim'

module RedditEmailer
  module Reddit
    class Html

      def initialize posts
        @posts = posts
      end

      def generate
        InlineStyle.process(html)
      end

      private

        attr_reader :posts

        def html
          Slim::Template.new('./lib/templates/layout.html.slim').render(Hashie::Mash.new({ body: body }))
        end

        def body
          posts.map do |post|
            Slim::Template.new('./lib/templates/shared/_post.html.slim').render(Hashie::Mash.new({ post: post }))
          end.join("\n")
        end
    end
  end
end
