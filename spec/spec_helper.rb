ENV['RACK_ENV'] = 'test'

require 'rubygems'
require 'bundler'
Bundler.setup
require File.dirname(__FILE__) + '/../pet_register'
