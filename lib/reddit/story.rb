require 'open-uri'
require 'cgi'

module Reddit
  class Story

    IMGUR_DOMAIN = 'imgur.com'

    def initialize json
      @json = json
    end

    def domain
      @json['data']['domain']
    end

    def url
      @json['data']['url']
    end

    def image_urls

      images = []

      if url.match(/\.(jpg|jpeg|gif|png)$/i)
        images = [ url ]
      elsif domain == IMGUR_DOMAIN

        # Lets try and extract out the imgur.com image :)
        #
        images = []

        begin
          images = Nokogiri::HTML(open(url)).search('div.left div.panel img').collect { |image| (image.attribute('data-src') || image.attribute('src')).to_s }
        rescue SocketError => e
          false
        end
      end

      images.collect do |image|
        is_config = $APP_CONFIG.image_scaler
        "#{is_config.url}/#{is_config.dimensions}/#{CGI.escape(image)}?api_key=#{is_config.api_key}"
      end
    end

    def method_missing(meth, *args, &block)
      @json['data'][meth.to_s]
    end
  end
end