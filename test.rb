require 'rubygems'
require 'bundler/setup'
require_relative 'amazon'
require 'dotenv'
require 'json'
Dotenv.load

client = Amazon.new(:in, ENV['AMAZON_KEY'], ENV['AMAZON_SECRET'], ENV['AMAZON_TAG'])
result = client.lookup('9780141043746', 'ISBN')
puts result.to_json