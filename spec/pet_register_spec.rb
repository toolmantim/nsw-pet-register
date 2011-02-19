require 'spec_helper'
require 'rack/test'

describe "Pets API" do
  include Rack::Test::Methods
  
  def app
    @app ||= PetRegister.new 
  end
  
  it "should give the type" do
    get '/dogs/breeds.json'
    last_response.should be_ok
  end
  
  it "should return the post code list" do
    get '/dogs/breeds/Deerhound/postcodes.json'
    last_response.should be_ok
  end
end