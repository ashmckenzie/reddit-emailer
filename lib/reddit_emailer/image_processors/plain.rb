# coding: utf-8

module RedditEmailer
  module ImageProcessors
    class Plain

      def initialize url
        @url = url
      end

      def images
        [ url ]
      end

      private

        attr_reader :url
    end
  end
end
