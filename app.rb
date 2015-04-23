require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require "sinatra/json"
require "sinatra/content_for"

require_relative 'goodreads'
require_relative 'amazon'

if development?
  require "sinatra/reloader"
  require 'dotenv'
  Dotenv.load
end

gr = Goodreads.new ENV['GOODREADS_KEY']

get '/:uid' do
  redirect "/#{params['uid']}/us"
end

get '/:uid/:locale' do
  locale = params[:locale]
  unless Amazon::ENDPOINTS[locale.to_sym]
    status 400
    body "Invalid Amazon locale"
  end
  client = Amazon.new(locale.to_sym, ENV['AMAZON_KEY'], ENV['AMAZON_SECRET'], ENV['AMAZON_TAG'])
  result = []
  lists = gr.to_read(params[:uid])
  lists.each do |sublist|
    client.lookup(sublist, 'ISBN').each do |book|
      result.push book
    end
  end
  #json result
  haml :books, :locals=>{:books=> result}
end

get '/' do
  haml :index
end

post '/' do
  begin
    # http://rubular.com/r/zB5iWuiUPe
    uid = params['profile_url'].scan(/https?:\/\/www.goodreads\.com\/user\/show\/(\d+)-.*/)[0][0]
    locale = params['locale']
  rescue Exception => e
    status 400
    body "Invalid profile url given"
    return
  end
  redirect "/#{uid}/#{locale}"
end