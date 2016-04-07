require 'sparkpost'

module RedditEmailer
  module Presenters
    class EmailSparkPost

      def initialize(subreddit, email_list)
        @subreddit = subreddit
        @email_list = email_list
      end

      def send!
        spark_post.transmission.send_message(to, from, subject, content)
      end

      private

        attr_reader :email_list, :subreddit

        def email_from_name
          ENV['EMAIL_FROM_NAME']
        end

        def email_from_email
          ENV['EMAIL_FROM_EMAIL']
        end

        def api_key
          ENV['SPARK_POST_API_KEY']
        end

        def spark_post
          SparkPost::Client.new(api_key)
        end

        def from
          '%s <%s>' % [ email_from_name, email_from_email ]
        end

        def subject
          html.title
        end

        def content
          html.content
        end

        def html
          Generators::HTML.new(subreddit)
        end

        def to
          email_list.map { |email| { email: email, name: email, header_to: '' } }
        end
    end
  end
end
