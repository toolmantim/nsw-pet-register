require 'lib/import'

class PetRegister < Sinatra::Application
  get '/' do
    200
  end
  
  get '/import' do # This is BAD
    Import.new.import 'dev'
  end
end
