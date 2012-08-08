module Reddit
  class StoryHtml
    include Celluloid

    attr_reader :story

    def initialize story
      @story = story
    end

    def generate_story_html
      @story_template ||= Haml::Engine.new(File.read('./lib/templates/shared/_story.html.haml'))
      @story_template.render(binding)
    end
  end
end
