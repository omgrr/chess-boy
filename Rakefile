$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require "rspec/core/rake_task"
require "chess_boy"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :release do
  image = `docker build .`.split("\n").last.split.last
  puts `docker tag #{image} registry.heroku.com/chess-boy/worker:latest`
  puts `docker push registry.heroku.com/chess-boy/worker:latest`
  puts `heroku container:release worker`
end
