# coding: utf-8

module RedditEmailer
  module Reddit
    module Validations
      class MinimalKitties

        def initialize post
          @post = post
        end

        def valid?
          result = true
          messages = []

          if post.title.match(patterns)
            result = false
            messages << 'Contains kittie references'
          end

          ValidationResult.new(result, messages)
        end

        private

          attr_reader :post

          def patterns
            Regexp.union([
              /kitty/i,
              /cat/i,
              /kitten/i
            ])
          end
      end
    end
  end
end
