# coding: utf-8

require 'mandrill'

module RedditEmailer
  module Reddit
    class Email

      def initialize html, email_list, subreddit, options
        @html = html
        @email_list = email_list
        @subreddit = subreddit
        @options = options
      end

      def send!
        Mandrill::API.new(config.mandrill.api_key).messages.send(message)
      end

      private

        attr_reader :html, :email_list, :subreddit, :options

        def config
          RedditEmailer::Config.instance
        end

        def message
          {
            to:           to,
            subject:      subject,
            from_name:    config.email.from_name,
            from_email:   config.email.from_email,
            html:         html
          }
        end

        def subject
          @email_subject ||= begin
            title = "Reddit '%{subreddit}' images" % { subreddit: subreddit }
            now = Time.now.strftime('%A %d %B %Y')

            "%{title} for %{now}" % { title: title, now: now }
          end
        end

        def to
          email_list.map { |email| { email: email, name: email, type: 'bcc' } }
        end
    end
  end
end
