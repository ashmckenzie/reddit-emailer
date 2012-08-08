module Reddit
  class Emailer

    def initialize subreddit, limit, email_list
      @stories = []

      @subreddit = subreddit
      @email_list = email_list
      @limit = limit
      @response = Hashie::Mash.new JSON.parse(RestClient.get(url, { 'Cache-Control' => 'no-cache' }))

      process_response

      unless $DEBUG_ON
        send_email
      else
        ap generate_html
      end
    end

    private

    def url
      @url ||= $APP_CONFIG.reddit.url % { :subreddit => @subreddit }
    end

    def process_response
      @response.data.children.each do |json|
        story = Reddit::Story.new(json)
        future = story.future :image_urls
        @stories << story unless future.value.empty?
        return if @stories.size == @limit
      end
    end

    def email_subject
      @email_subject ||= "%{title} for %{now}" % { :title => title, :now => now }
    end

    def send_email
      body = InlineStyle.process(generate_html, :stylesheets_path => "./lib/templates/styles")

      mail = Mail.new
      mail.from = $APP_CONFIG.email.from
      mail.to = @email_list
      mail.subject = email_subject
      mail.html_part do
        content_type  'text/html; charset=UTF-8'
        body body
      end

      debug_log(mail.to_s)

      unless $DRY_ON
        mail.delivery_method :sendmail
        mail.deliver!
      else
        require 'tempfile'
        filename = Tempfile.new(['reddit-emailer', '.html'])
        File.open(filename, 'w') { |f| f.write(body) }
        `open #{filename.path}`
        sleep(2)
      end
    end

    def now
      Time.now.strftime('%A %d %B %Y')
    end

    def title
      "Top %{limit} images for Reddit '%{subreddit}'" % { :limit => @limit, :subreddit => @subreddit }
    end

    def generate_html
      body = generate_body_html
      email_template = Haml::Engine.new(File.read('./lib/templates/email.html.haml'))
      email_template.render(binding)
    end

    def generate_body_html
      stories_html = []
      @stories.each do |story|
        story_html = StoryHtml.new(story)
        future = story_html.future :generate_story_html
        stories_html << future.value
        # stories_html << generate_story_html(story)
      end
      stories_html.join("\n")
    end
  end
end
