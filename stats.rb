require 'nokogiri'
require 'pp'
require 'date'

def read_stats(year)
  doc = File.open("tests/read.xml") { |f| Nokogiri::XML(f) }

  counter = Array.new(366) { 0 }
  reviews = doc.xpath('//reviews//review')

  reviews.each do |review|
    date_read = DateTime.parse review.css('read_at').text

    page_count = review.css('book num_pages').text.to_i

    if date_read.year === year
      counter[date_read.strftime('%j').to_i] += page_count
    end
  end

  total_count = 0

  counter.each_with_index do |count, day|
    total_count += count
    counter[day] = total_count
  end

  counter
end

puts read_stats(2016)