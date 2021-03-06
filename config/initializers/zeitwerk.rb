# frozen_string_literal: true

require 'zeitwerk'
require 'bundler'

APP_PATH = Bundler.root.join('app')
LIB_PATH = Bundler.root.join('lib')

loader = Zeitwerk::Loader.new
loader.inflector.inflect(
  'simple_html_href_parser' => 'SimpleHTMLHREFParser',
  'url_validator' => 'URLValidator'
)
loader.push_dir(APP_PATH)
Dir[File.join(APP_PATH, '*')].sort.each do |dir|
  loader.push_dir(dir)
end
loader.push_dir(LIB_PATH)
loader.setup
loader.eager_load
