module RedditEmailer
  module Reddit
    class ValidationResult
      attr_reader :messages

      def initialize(result, messages = [])
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
