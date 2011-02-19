require 'sequel'
require 'open-uri'

class Import
  
  attr_accessor :env
  
  def db
    @db ||= Sequel.connect(ENV['DATABASE_URL'] || 'mysql://root:@localhost/dogwars_dev')
  end
  
  def create_table
    db.create_table! :pets do
      primary_key :id
      String :type
      String :name
      String :postcode
      String :colour
      String :breed
      String :crossbreed
    end
  end
  
  def insert
    filename = File.dirname(__FILE__) + '/../fixtures/appsnsw_export_with_postcode.csv'
    File.open(filename, "rb:UTF-16LE:UTF-8") do |f|
      while (l = f.gets)
        fields = l.split("\t").map {|f| f.strip}
        arr = [
          fields[0],
          fields[1].downcase,
          fields[2].downcase,
          fields[3] || 0,
          fields[4],
          fields[5]
              ]
        # p arr
        db[:pets].import [:name, :type, :colour, :postcode, :breed, :crossbreed], [arr], :slice => 500
      end
    end
  end
  
  def index
    db.add_index :pets, [:breed, :type, :name]
  end
  
  def import
    create_table
    insert
    index
  end
end
