module RedditEmailer
  module ImageProcessors
    module Imgur
      class Base
        def initialize(url)
          @url = url
        end

        def links
          raise NotImplementedError
        end

        private

          attr_reader :url

          def client_id
            ENV['IMGUR_CLIENT_ID']
          end

          def authorization_header
            { 'Authorization' => "Client-ID #{client_id}" }
          end

          def headers
            authorization_header
          end

          def response
            Hashie::Mash.new(JSON.parse(RestClient.get(api_url, headers))).data
          end

          def api_url
            match = url.match(URL_REGEX)
            if match
              api_url = API_BASE_URL
              api_url += match['type'] ? "/album/#{match['path']}" : "/image/#{match['path']}"
              "#{api_url}.json"
            else
              fail CannotDetermineURL, 'Cannot determine API URL for %s' % [ url ]
            end
          end
      end
    end
  end
end
