require 'sinatra'
require 'bundler'

Bundler.require(:default)

require './models.rb'

class Skellington < Sinatra::Base

  DataMapper.finalize

  set :root, File.dirname(__FILE__)

  DataMapper.setup :default, ENV['DATABASE_URL']

  configure :development do
    Bundler.require :development
    DataMapper.auto_upgrade!
    require 'sinatra/reloader'
    register Sinatra::Reloader
  end

  configure :production do
    Bundler.require :production
  end

  configure :test do
    Bundler.require :test
  end

end
