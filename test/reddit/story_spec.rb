require 'spec_helper'

json = Hashie::Mash.new JSON.parse <<EOS
{
  "data":{
    "domain":"imgur.com",
    "subreddit":"aww",
    "title":"I wanted a car, my wife wanted a dog.  I'm bad at negotiation.",
    "url":"http://imgur.com/a/da4yn#1"
  }
}
EOS

require 'reddit/story'

describe Reddit::Story do

  before do
    $APP_CONFIG = Hashie::Mash.new({ image_scaler: { url: 'http://something.com', dimensions: '10-10', api_key: 'abc123', max_album_images: 3 } })
  end

  it "should handle image URLs with #blah at the end" do
    rs = Reddit::Story.new json
    rs.url.must_equal 'http://imgur.com/a/da4yn'
  end

  it "should return the correct array of images" do
    Reddit::Story.any_instance.stubs(:extract_images).returns([ 'http://i.imgur.com/DgY6H.jpg' ])
    rs = Reddit::Story.new(json)
    rs.image_urls.must_equal [ 'http://something.com/10-10/http%3A%2F%2Fi.imgur.com%2FDgY6H.jpg?api_key=abc123' ]
  end

  it "should handle weird URL's correctly" do
    Reddit::Story.any_instance.stubs(:url).returns('http://something.weird/123')
    rs = Reddit::Story.new(json)
    rs.image_urls.must_equal [ ]
  end
end
