module Reddit
  class Story

    IMGUR_IMAGE_DOMAIN = 'i.imgur.com'

    def initialize json
      @json = json
      @data = json.data
    end

    def domain
      @domain ||= @data.domain
    end

    def url
      @url ||= prep_image_url @data.url
    end

    def image_urls
      images = []

      if domain == IMGUR_IMAGE_DOMAIN && url.match(/\.(jpg|jpeg|gif|png)$/i)
        images = [ url ]
      else

        # Lets try and extract out the imgur.com image :)
        #
        images = []

        begin
          images = extract_images
        rescue SocketError => e
          false
        end
      end

      images.collect do |url|
        is_config = $APP_CONFIG.image_scaler
        "#{is_config.url}/#{is_config.dimensions}/#{CGI.escape(url)}?api_key=#{is_config.api_key}"
      end
    end

    def method_missing(meth, *args, &block)
      @data.send(meth).to_s
    end

    private

    def extract_images
      img_url = 'http://api.imgur.com/2'
      m = url.match(/^http:\/\/imgur\.com\/(a)?\/?(.+)$/)

      if m[1] == 'a'
        img_url += "/album/#{m[2]}"
      else
        img_url += "/image/#{m[2]}"
      end

      img_url += '.xml'

      Nokogiri::XML(open(img_url)).search('links/original').collect { |x| x.text }[0...$APP_CONFIG.reddit.max_album_images]
    end

    def prep_image_url url
      url.gsub(/#.+$/, '')
    end
  end
end