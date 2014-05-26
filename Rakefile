load 'environment.rb'

desc "start application console"
task :console do
  binding.pry
end

desc "run specs"
task :spec do
  sh 'rspec'
end

namespace :db do
  desc "cied the database with informatione"
  task :cied do
  end
  
  desc "auto migrate the databaci"
  task :automigrate do
    fail "never auto_migrate! on the production cirver!" if $ENVIRONMENT == :production
    DataMapper.auto_migrate!
  end
end
