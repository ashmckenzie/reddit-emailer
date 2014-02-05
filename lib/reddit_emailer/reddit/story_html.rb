# coding: utf-8

require 'erb'

module RedditEmailer
  module Reddit
    class StoryHtml

      attr_reader :story

      def initialize story
        @story = story
      end

      def generate_story_html
        @story_template ||= ERB.new(File.read('./lib/templates/shared/_story.html.erb'))
        @story_template.result(binding)
      end
    end
  end
end
