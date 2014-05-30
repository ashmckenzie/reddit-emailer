# coding: utf-8

module RedditEmailer
  module Reddit
    class Validation

      def initialize post, args
        @post = post
        @args = args
      end

      private

        attr_reader :post, :args

    end
  end
end
