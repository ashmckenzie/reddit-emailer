require 'thread'
require 'thwait'

module RedditEmailer
  module Generators
    module Jobs
      class PostRenderRunner

        def initialize(posts)
          @posts = posts
        end

        def run
          jobs = {}
          posts.each_with_index do |post, i|
            jobs[i] = Thread.new { Jobs::PostRender.new(post).render }
          end
          ThreadsWait.all_waits(jobs.values)
          jobs.values.map(&:value).join("\n")
        end

        private

          attr_reader :posts
      end
    end
  end
end
