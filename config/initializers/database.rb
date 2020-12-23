require 'sqlite3'
require 'active_record'
require 'logger'

ActiveRecord::Base.logger = Logger.new($stdout)
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  dbfile: ':memory:',
  pool: 5,
  timeout: 5000,
  database: 'simple_nudge_dev'
)
