require 'simplecov' unless RUBY_VERSION.match /^1.8/

lib_path = File.expand_path('../../../lib', __FILE__)
$LOAD_PATH << lib_path unless $LOAD_PATH.include? lib_path
require 'gitsu'
