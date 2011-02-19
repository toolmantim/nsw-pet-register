require 'rubygems'
require 'sinatra'
require './pet_register'

set :run, false
set :environment, :production

app = Rack::Builder.new do
  map '/' do
    run PetRegister
  end
end.to_app

log = File.new("app.log", "a")
STDOUT.reopen(log)
STDERR.reopen(log)

run app

