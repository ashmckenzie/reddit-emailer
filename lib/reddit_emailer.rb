require 'erb'
require 'json'
require 'open-uri'

require_relative 'reddit_story'

class RedditEmailer

  def initialize subreddit, limit, email_list
    @reddit_stories = []

    @subreddit = subreddit
    @email_list = email_list
    @limit = limit
    @response = JSON.parse(RestClient.get(url, { 'Cache-Control' => 'no-cache' }))

    process_response

    unless $DEBUG_ON
      send_email
    else
      ap generate_html
    end
  end

  private

  def url
    @url ||= $CONFIG['reddit']['url'] % { :subreddit => @subreddit }
  end

  def process_response
    @response['data']['children'].each do |json|
      story = RedditStory.new(json)
      @reddit_stories << story unless story.image_urls.empty?
      return if @reddit_stories.size == @limit
    end
  end

  def email_subject
    @email_subject ||= "%{title} for %{now}" % { :title => title, :now => now }
  end

  def send_email
    body = InlineStyle.process(generate_html, :stylesheets_path => "./lib/templates/styles")

    mail = Mail.new
    mail.from = $CONFIG['email']['from']
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
    email_template = ERB.new(File.read('./lib/templates/email.html.erb'))
    email_template.result(binding)
  end

  def generate_body_html
    reddit_stories_html = []
    @reddit_stories.each do |story|
      reddit_stories_html << generate_story_html(story)
    end
    reddit_stories_html.join("\n")
  end

  def generate_story_html story
    @story_template ||= ERB.new(File.read('./lib/templates/shared/_reddit_story.html.erb'))
    @story_template.result(binding)
  end

end
