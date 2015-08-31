module RedditEmailer
  module Reddit
    module Validations
      class Base

        def initialize(post, args)
          @post = post
          @args = args
        end

        private

          attr_reader :post, :args

      end
    end
  end
end
