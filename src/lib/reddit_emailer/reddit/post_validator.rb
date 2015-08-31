module RedditEmailer
  module Reddit
    class PostValidator

      def initialize(post, validations)
        @post = post
        @validations = validations
      end

      def valid?
        @valid ||= !results.detect { |r| !r.valid? }
      end

      def messages
        @messages ||= results.map { |r| r.messages }.flatten
      end

      private

        attr_reader :post, :validations

        def filter_class(filter)
          filter.split('_').map { |x| x.capitalize }.join('')
        end

        def results
          @results ||= begin
            validations.map do |klass_key, args|
              klass = filter_class(klass_key)
              Validations.const_get(klass).new(post, args).valid?
            end
          end
        end
    end
  end
end
