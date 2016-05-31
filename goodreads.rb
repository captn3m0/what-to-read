require 'httparty'

class Goodreads
  include HTTParty
  base_uri 'https://www.goodreads.com'

  def initialize(key)
    @key=key
  end

  def to_read(uid)
    response = self.class.get "/review/list.xml?v=2&shelf=to-read&id=#{uid}&key=#{@key}"
    response['GoodreadsResponse']['reviews']['review'].map do |review|
      review['book']['isbn13']
    end
    .compact.each_slice(10).to_a
  end

  def get_book_ids(isbn)
    self.class.get "/book/isbn_to_id/#{isbn}?key=#{@key}"
  end
end