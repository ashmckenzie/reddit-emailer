require 'erb'
require 'json'

require_relative 'reddit_story'

class RedditEmailer

  MAX_STORIES = 5
  URL = 'http://www.reddit.com/r/aww.json'

  EMAIL_FROM = 'Ash McKenzie <ash@greeworm.com.au>'
  EMAIL_SUBJECT = "Top 5 Reddit Aww's for #{Time.now.strftime('%A %d %B %Y')}"

  def initialize email_list
    @reddit_stories = []

    @email_list = email_list
    @response = JSON.parse RestClient.get(URL)

    process_response
    send_email
  end

  private

  def process_response
    @response['data']['children'].each do |json|
      story = RedditStory.new(json)
      @reddit_stories << story if story.image_url
      return if @reddit_stories.size == MAX_STORIES
    end
  end

  def EMAIL_SUBJECT
  end

  def send_email
    body = InlineStyle.process(generate_html, :stylesheets_path => "./lib/templates/styles")

    mail = Mail.new
    mail.from = EMAIL_FROM
    mail.to = @email_list
    mail.subject = EMAIL_SUBJECT
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

  def generate_html
    body = generate_body_html
    title = EMAIL_SUBJECT
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