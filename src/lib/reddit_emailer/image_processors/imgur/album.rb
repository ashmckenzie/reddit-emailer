module RedditEmailer
  module ImageProcessors
    module Imgur
      class Album < Base
        def links
          images.map { |i| i.link }
        end

        private

          def images
            @images ||= response.images
          end
      end
    end
  end
end
