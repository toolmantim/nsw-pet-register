require 'sinatra'
require 'json'
require './lib/import'
class PetRegister < Sinatra::Application  
  helpers do
    def singularize(string)
      s = string.to_s
      s[-1] == 's' ? s.slice(0, s.length - 1) : s
    end
  end
  
  configure do |environment|
    DB = Sequel.connect(ENV['DATABASE_URL'] || 'mysql://root:@localhost/dogwars_dev')
  end
  
  get '/' do
    200
  end
  
  get '/:type/breeds.json' do |type|
    content_type :json
    DB[:pets].filter("type = ?", singularize(type)).group_and_count(:breed).all.to_json
  end
end
