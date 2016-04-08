module RedditEmailer
  module ImageProcessors
    module Imgur
      class Image < Base
        def links
          [ response.link ]
        end
      end
    end
  end
end
