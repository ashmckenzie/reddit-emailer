require 'mandrill'

module RedditEmailer
  module Presenters
    class EmailMandrill

      def initialize(subreddit, email_list)
        @subreddit = subreddit
        @email_list = email_list
      end

      def send!
        mandrill.messages.send(message)
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
          ENV['MANDRILL_API_KEY']
        end

        def mandrill
          Mandrill::API.new(api_key)
        end

        def message
          {
            to:           to,
            subject:      subject,
            from_name:    email_from_name,
            from_email:   email_from_email,
            html:         content
          }
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
          email_list.map { |email| { email: email, name: email, type: 'bcc' } }
        end
    end
  end
end
