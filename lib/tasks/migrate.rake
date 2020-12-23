require 'bundler'
require 'pathname'
require "#{Bundler.root}/config/initializers/database.rb"
Dir[File.join(Bundler.root, 'migrations', '/*')].sort.each do |file|
  require file
end

namespace :migrate do
  task :up do
    CreateNutchRequests.migrate(:up)
    CreateJobQueues.migrate(:up)
    CreateSiteMaps.migrate(:up)
  end

  task :down do
    CreateJobQueues.migrate(:down)
    CreateSiteMaps.migrate(:down)
    CreateNutchRequests.migrate(:down)
  end
end
