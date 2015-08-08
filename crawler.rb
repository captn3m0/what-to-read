require 'unirest'
require 'uri'
require 'pp'
require 'oga'

class Crawler
  attr_reader :asins
  def initialize(url)
    unless validate_url(url)
      throw "Invalid URL"
    end
    response = Unirest.get url
    @asins = find_asins(response.body)
      .each_slice(10).to_a
  end

  def find_asins(body)
    asins = []
    html = Oga.parse_html(body)

    html.css('a').each do |anchor|
      link = anchor.get('href')
      if link
        puts link
        match = link.match("amazon.com/([\\w-]+/)?(dp|gp/product)/(\\w+/)?(\\w{10})")
        if match and match.size >=4
          asins.push match[4]
        end
      end
    end
    asins
  end

  def validate_url(url)
    uri = URI.parse(url)
    uri.kind_of?(URI::HTTP) or uri.kind_of?(URI::HTTPS)
  end
end