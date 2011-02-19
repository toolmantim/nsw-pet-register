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

run app

