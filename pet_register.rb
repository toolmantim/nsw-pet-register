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
    DB[:pets].filter("type = ?", singularize(type)).group_and_count(:breed).map{|r| {r[:breed] => r[:count]} }.to_json
  end
  
  get '/:type/breeds/:breed/postcodes.json' do |type, breed|
    content_type :json
    dataset = if params[:crossbreed] == '?'
      DB[:pets].filter("type = ? and breed = ? and crossbreed IS NULL", singularize(type), breed)
    else
      DB[:pets].filter("type = ? and breed = ? and crossbreed = ?", singularize(type), breed, params[:crossbreed])
    end
    dataset.group_and_count(:postcode).map{|r| {r[:postcode] => r[:count]} }.to_json
  end

end
