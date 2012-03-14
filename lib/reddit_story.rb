require 'open-uri'

class RedditStory

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

  def image_url
    the_image_url = false

    if url.match(/\.(jpg|jpeg|gif|png)$/i)
      the_image_url = url
    elsif domain == IMGUR_DOMAIN

      # Lets try and extract out the imgur.com image :)
      #
      begin
        unless the_image_url = Nokogiri::HTML(open(url)).search('.main-image img').attribute('src').to_s
          the_image_url = false
        end
      rescue SocketError => e
        false
      end
    end

    if the_image_url
      "#{$CONFIG['image_scaler_url']}/#{$CONFIG['image_scaler_dimensions']}?file=#{url}"
    else
      false
    end
  end

  def method_missing(meth, *args, &block)
    @json['data'][meth.to_s]
  end
end
