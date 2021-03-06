

module RedditEmailer
  module Reddit
    module Validations
      class TitleFilter < Base

        def valid?
          result = true
          messages = []

          if post.title.match(patterns)
            result = false
            messages << "Contains %s" % [ args.to_s ]
          end

          ValidationResult.new(result, messages)
        end

        private

          def patterns
            regex = args.map do |a|
              Regexp.new(a, Regexp::IGNORECASE)
            end

            Regexp.union(regex)
          end
      end
    end
  end
end
