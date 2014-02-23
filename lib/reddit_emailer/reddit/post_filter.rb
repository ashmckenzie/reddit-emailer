# posts << p unless p.image_urls.empty?

# coding: utf-8

module RedditEmailer
  module Reddit
    class PostFilter

      def initialize post, filters
        @post = post
        @filters = filters
      end

      def valid?
        @valid ||= !results.detect { |r| !r.valid? }
      end

      def messages
        @messages ||= results.map { |r| r.messages }.flatten
      end

      private

        attr_reader :post, :filters

        def filter_class filter
          filter.split('_').map { |x| x.capitalize }.join('')
        end

        def results
          @results ||= begin
            filters.keys.map do |filter|
              Filters.const_get(filter_class(filter)).new(post).valid?
            end
          end
        end
    end
  end
end
