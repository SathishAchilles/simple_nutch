require 'bundler'
require 'rspec/core/rake_task'
Dir.glob("#{Bundler.root}/lib/tasks/*.rake").each { |file| import file }

RSpec::Core::RakeTask.new(:spec)

task default: :spec
