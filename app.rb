require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require "sinatra/json"
require "sinatra/content_for"
require 'rack/pratchett'
require 'haml'

require_relative "lib"
require_relative "crawler"
require_relative 'goodreads'

if development?
  require "sinatra/reloader"
  require 'dotenv'
  Dotenv.load
end

gr = Goodreads.new ENV['GOODREADS_KEY']
use Rack::Pratchett

get '/:uid' do
  pass unless !!(params[:uid] =~ /\A[-+]?[0-9]+\z/)
  redirect "/#{params[:uid]}/us"
end

get '/crawl/:locale' do
  url = params[:url]
  lists = Crawler.new(url).asins
  books = lookup_list_on_amazon(params[:locale], lists)
  #json result
  haml :books, :locals=>{:books=> books}
end

get '/:uid/:locale' do
  lists = gr.to_read(params[:uid])
  books = lookup_list_on_amazon(params[:locale], lists)
  #json result
  haml :books, :locals=>{:books=> books}
end

get '/' do
  haml :index
end

post '/' do
  begin
    locale = params['locale']
    # http://rubular.com/r/zB5iWuiUPe
    uid = params['profile_url'].scan(/https?:\/\/www.goodreads\.com\/user\/show\/(\d+)-.*/)[0][0]
  rescue Exception => e
    redirect "/crawl/#{locale}?url="+params['profile_url']
    return
  end
  redirect "/#{uid}/#{locale}"
end