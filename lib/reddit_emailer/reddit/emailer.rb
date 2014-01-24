# coding: utf-8

require 'tempfile'
require 'json'
require 'rest-client'
require 'celluloid'
# require 'inline-style'
require 'mandrill'
require 'erb'

module RedditEmailer
  module Reddit
    class Emailer

      include Celluloid

      def initialize email_list, subreddit, options
        @stories = []

        @email_list = email_list
        @subreddit = subreddit
        @options = options

        @limit = options[:limit]
      end

      def send!
        process_response!
        send_email!
      end

      private

        attr_reader :subreddit, :email_list, :limit, :options, :response
        attr_accessor :stories

        def config
          RedditEmailer::Config.instance
        end

        def response
          Hashie::Mash.new JSON.parse(RestClient.get(url, { 'Cache-Control' => 'no-cache' }))
        end

        def url
          @url ||= config.reddit.url % { subreddit: subreddit }
        end

        def process_response!
          response.data.children.each do |json|
            story = Reddit::Story.new(json)
            future = story.future :image_urls
            stories << story unless future.value.empty?

            return if stories.size == limit
          end
        end

        def email_subject
          @email_subject ||= "%{title} for %{now}" % { title: title, now: now }
        end

        def dry_mode?
          options[:dry_mode]
        end

        def send_email!
          # html = InlineStyle.process(generate_html, :stylesheets_path => "./lib/templates/styles")
          html = generate_html

          if dry_mode?
            filename = Tempfile.new(['reddit-emailer', '.html'])
            File.open(filename, 'w') { |f| f.write(html) }
            `open #{filename.path}`
            sleep(2)
          else
            m = Mandrill::API.new(config.mandrill.api_key)

            message = {
              to:           to,
              subject:      email_subject,
              from_name:    config.email.from_name,
              from_email:   config.email.from_email,
              html:         html
            }

            m.messages.send(message)
          end
        end

        def to
          email_list.map do |email|
            {
              'email' => email,
              'name'  => email,
              'type'  => 'bcc'
            }
          end
        end

        def now
          Time.now.strftime('%A %d %B %Y')
        end

        def title
          "Top %{limit} images for Reddit '%{subreddit}'" % { limit: limit, subreddit: subreddit }
        end

        def generate_html
          body = generate_body_html
          email_template = ERB.new(File.read('./lib/templates/layout.html.erb'))
          email_template.result(binding)
        end

        def generate_body_html
          stories_html = []

          stories.each do |story|
            story_html = StoryHtml.new(story)
            future = story_html.future :generate_story_html
            stories_html << future.value
          end

          stories_html.join("\n")
        end
      end
  end
end
