require 'sinatra'
require 'json'
require 'sequel'
require 'logger'
require './lib/import'
class PetRegister < Sinatra::Application  
  
  set :haml, {:format => :html5, :attr_wrapper => '"'}
  
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
    haml :index
  end
  
  get '/:type/breeds.json' do |type|
    content_type :json
    DB[:pets].filter("type = ?", singularize(type)).group_and_count(:breed).map{|r| {r[:breed] => r[:count]} }.to_json
  end
  
  get '/:type/names.json' do |type|
    content_type :json
    DB[:pets].filter("type = ?", singularize(type)).group_and_count(:name).map{|r| {r[:name] => r[:count]} }.to_json
  end
  
  get '/:type/breeds/:breed/postcodes.json' do |type, breed|
    content_type :json
    crossbreed = params[:crossbreed] == '?' ? nil : params[:crossbreed]
    DB[:pets].filter("type = ? and breed = ? and crossbreed = ?", singularize(type), breed, crossbreed).group_and_count(:postcode).map{|r| {r[:postcode] => r[:count]} }.to_json
    # DB[:pets].filter("type = ? and breed = ?", singularize(type), breed).group_and_count(:postcode).map{|r| {r[:postcode] => r[:count]} }.to_json
  end
  
  

end
