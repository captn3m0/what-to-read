require 'rubygems'
require 'bundler/setup'
require_relative 'amazon'
require_relative 'goodreads'
require 'dotenv'
require 'json'
require 'pp'
Dotenv.load

gr = Goodreads.new ENV['GOODREADS_KEY']

pp gr.get_book_ids('9780439136365')

exit

h = {'RelationshipType' => 'AuthorityTitle', 'Condition'=> 'New'}
puts h
# exit
client = Amazon.new(:in, ENV['AMAZON_KEY'], ENV['AMAZON_SECRET'], ENV['AMAZON_TAG'])
result = client.lookup('9780439136365', 'ISBN', h)
puts result.to_json