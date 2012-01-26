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
    if url.match(/\.(jpg|jpeg|gif|png)$/i)
      url
    elsif domain == IMGUR_DOMAIN

      # Lets try and extract out the imgur.com image :)
      #
      if image_url = Nokogiri::HTML(open(url)).search('.main-image img').attribute('src').to_s
        image_url
      else
        false
      end
    end
  end
end