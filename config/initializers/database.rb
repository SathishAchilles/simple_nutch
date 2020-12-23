require 'pg'
require 'active_record'
require 'logger'
require 'yaml'
require 'bundler'

db_config = YAML.load_file("#{Bundler.root}/config/database.yaml")
env = ENV['SIMPLE_NUTCH_ENV'] || 'development'

ActiveRecord::Base.logger = Logger.new($stdout)
# ActiveRecord::Base.logger.level = Logger::WARN
ActiveRecord::Base.establish_connection(db_config[env])
