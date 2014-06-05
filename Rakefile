
desc 'start application console'
task :console do
  require './environment.rb'
  require 'irb'
  ARGV.clear
  IRB.start
end

desc 'run specs'
task :spec do
  require './environment.rb'
  sh 'rspec'
end

namespace :db do
  desc 'seed the database with information'
  task :seed do
  require './environment.rb'
  end
  
  desc 'auto-migrate the database (deletes data)'
  task :migrate do
    require './environment.rb'
    fail 'never auto_migrate! on the production server!' if $ENVIRONMENT == :production
    DataMapper.auto_migrate!
  end

  desc 'auto-upgrade the database schema (data safe)'
  task :upgrade do
    require './environment.rb'
    DataMapper.auto_upgrade!
  end
end
