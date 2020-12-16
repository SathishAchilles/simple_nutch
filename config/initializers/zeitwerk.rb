# frozen_string_literal: true
require 'zeitwerk'
require 'bundler'

APP_PATH = Bundler.root.join('app')

loader = Zeitwerk::Loader.new
loader.push_dir(APP_PATH)
loader.push_dir(APP_PATH.join('services'))
loader.setup
loader.eager_load
