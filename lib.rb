require_relative 'amazon'

def lookup_list_on_amazon(locale, lists)
	unless Amazon::ENDPOINTS[locale.to_sym]
    status 400
    body "Invalid Amazon locale"
  end
  client = Amazon.new(locale.to_sym, ENV['AMAZON_KEY'], ENV['AMAZON_SECRET'], ENV['AMAZON_TAG'])
  result = []

  lists.each do |sublist|
    client.lookup(sublist, 'ISBN').each do |book|
      result.push book
    end
  end
  result
end