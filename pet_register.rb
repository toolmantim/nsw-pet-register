require 'sinatra'
require 'json'
require './lib/import'
require File.dirname(__FILE__) + '/lib/connectable'
class PetRegister < Sinatra::Application
  include Connectable
  
  helpers do
    def singularize(string)
      s = string.to_s
      s[-1] == 's' ? s.slice(0, s.length - 1) : s
    end
  end
  
  get '/' do
    200
  end
  
  get '/:type/breeds.json' do |type|
    content_type :json
    db[:pets].filter("type = ?", singularize(type)).group_and_count(:breed).all.to_json
  end
end
