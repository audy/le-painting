require 'sinatra'
require 'bcrypt'
require 'bundler'

Bundler.require(:default)

require './models.rb'

class Skellington < Sinatra::Base

  DataMapper.finalize

  set :root, File.dirname(__FILE__)

  DB_PATH = File.join(File.dirname(__FILE__), 'db')

  configure :development do
    Bundler.require :development
    DataMapper.setup(:default,
                     :adapter => 'sqlite',
                     :database => File.join(DB_PATH, 'development.db'))
    DataMapper.auto_upgrade!
    require 'sinatra/reloader'
    register Sinatra::Reloader
  end

  configure :production do
    Bundler.require :production
    p ENV['DATABASE_URL']
    DataMapper.setup(:default,
                     :database => ENV['DATABASE_URL']
                    )
  end

  configure :test do
    Bundler.require :test
    DataMapper.setup(:default, "sqlite::memory:")
  end

end
