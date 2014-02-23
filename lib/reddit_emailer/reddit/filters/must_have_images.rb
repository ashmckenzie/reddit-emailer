# coding: utf-8

module RedditEmailer
  module Reddit
    module Filters
      class MustHaveImages

        def initialize post
          @post = post
        end

        def valid?
          result = true
          messages = []

          if post.image_urls.empty?
            result = false
            messages = [ 'Does not contain images' ]
          end

          FilterResult.new(result, messages)
        end

        private

          attr_reader :post

      end
    end
  end
end
