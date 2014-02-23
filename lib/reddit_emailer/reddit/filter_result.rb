# coding: utf-8

module RedditEmailer
  module Reddit
    class FilterResult

      attr_reader :messages

      def initialize result, messages=[]
        @result = result
        @messages = messages
      end

      def valid?
        result
      end

      private

        attr_reader :result

    end
  end
end
