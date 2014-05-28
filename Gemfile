source 'http://rubygems.org'

ruby '2.1.2'

gem 'sinatra'
gem 'haml'
gem 'encrypted_cookie'
gem 'data_mapper'
gem 'dm-postgres-adapter'
gem 'carrierwave'
gem 'carrierwave-datamapper'

gem 'sinatra-assetpack', :require => 'sinatra/assetpack', :git => 'git://github.com/rstacruz/sinatra-assetpack.git'
gem 'uglifier'

group :test do
  gem 'rspec'
  gem 'webrat'
  gem 'rack-test', :require => 'rack/test'
end

group :development do
  gem 'sqlite3'
  gem 'dm-sqlite-adapter'
  gem 'sinatra-reloader'
  gem 'pry'
end

group :production do
  gem 'pg'
  gem 'dm-postgres-adapter'
end
