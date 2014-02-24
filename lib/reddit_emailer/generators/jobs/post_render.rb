# coding: utf-8

require 'hashie'
require 'slim'

module RedditEmailer
  module Generators
    module Jobs
      class PostRender

        def initialize post
          @post = post
        end

        def render
          attrs = Hashie::Mash.new({ post: post })
          Slim::Template.new('./lib/templates/shared/_post.html.slim').render(attrs)
        end

        private

          attr_reader :post
      end
    end
  end
end
