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
    DB[:pets].filter("type = ?", singularize(type)).group_and_count(:name).order(:count.desc).limit(40).map{|r| {r[:name] => r[:count]} }.to_json
  end
  
  get '/:type/breeds/:breed/postcodes.json' do |type, breed|
    content_type :json
    dataset = if params[:crossbread].nil?
      DB[:pets].filter("type = ? and breed = ?", singularize(type), breed)
    elsif params[:crossbreed] == '?'
      DB[:pets].filter("type = ? and breed = ? and crossbreed IS NULL", singularize(type), breed)
    else
      DB[:pets].filter("type = ? and breed = ? and crossbreed = ?", singularize(type), breed, params[:crossbreed])
    end
    dataset.group_and_count(:postcode).map{|r| {r[:postcode] => r[:count]} }.to_json
  end
  
  

  get '/:type/names.json' do |type|
    content_type :json
    DB[:pets].filter("type = ?", singularize(type)).order(:count.desc).group_and_count(:name).limit(40).map {|r| {r[:name] => r[:count]} }.to_json
  end


end
