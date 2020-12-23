require 'bundler'
require 'pathname'
require 'active_record'

root = Bundler.root
db_config = YAML.load_file(root.join('config/database.yaml'))
env = ENV['SIMPLE_NUTCH_ENV'] || 'development'

ActiveRecord::Tasks::DatabaseTasks.env = env
ActiveRecord::Tasks::DatabaseTasks.database_configuration = db_config
ActiveRecord::Tasks::DatabaseTasks.db_dir = root.join('db').to_s
ActiveRecord::Tasks::DatabaseTasks.migrations_paths = [root.join('db/migrate').to_s]

ActiveRecord::Tasks::DatabaseTasks.root = root

namespace :db do
  task :create do
    ActiveRecord::Tasks::DatabaseTasks.create(db_config[env])
  end

  task :drop do
    ActiveRecord::Tasks::DatabaseTasks.drop(db_config[env])
  end

  task :migrate do
    ActiveRecord::Tasks::DatabaseTasks.migrate
  end
end
