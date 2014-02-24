# coding: utf-8

require 'mandrill'

module RedditEmailer
  module Presenters
    class Email

      def initialize subreddit, email_list
        @subreddit = subreddit
        @email_list = email_list
      end

      def send!
        Mandrill::API.new(config.mandrill.api_key).messages.send(message)
      end

      private

        attr_reader :email_list, :subreddit

        def config
          RedditEmailer::Config.instance
        end

        def message
          {
            to:           to,
            subject:      html.title,
            from_name:    config.email.from_name,
            from_email:   config.email.from_email,
            html:         html.content
          }
        end

        def html
          Generators::Html.new(subreddit)
        end

        def to
          email_list.map { |email| { email: email, name: email, type: 'bcc' } }
        end
    end
  end
end
