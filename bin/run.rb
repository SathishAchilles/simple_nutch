#!/usr/bin/env ruby
# executable to run web server log analyzer
require 'bundler'
Dir[File.join(Bundler.root, 'config', 'initializers', '*.rb')].sort.each do |file|
  require file
end

if $PROGRAM_NAME == __FILE__
  crawl_url = ARGV[0]
  NutchService.call(crawl_url)
end
