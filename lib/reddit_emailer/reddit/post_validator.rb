# posts << p unless p.image_urls.empty?

# coding: utf-8

module RedditEmailer
  module Reddit
    class PostValidator

      def initialize post, validations
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

        def filter_class filter
          filter.split('_').map { |x| x.capitalize }.join('')
        end

        def results
          @results ||= begin
            validations.keys.map do |filter|
              Validations.const_get(filter_class(filter)).new(post).valid?
            end
          end
        end
    end
  end
end
