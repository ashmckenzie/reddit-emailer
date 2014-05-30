# coding: utf-8

module RedditEmailer
  module Reddit
    module Validations
      class MustHaveImages < Validation

        def valid?
          result = true
          messages = []

          if post.image_urls.empty?
            result = false
            messages << 'Does not contain images'
          end

          ValidationResult.new(result, messages)
        end
      end
    end
  end
end
