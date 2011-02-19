require 'sequel'
require 'open-uri'

class Import
  
  attr_accessor :env
  
  def db
    @db ||= Sequel.mysql "dogwars_dev", :host => '127.0.0.1', :user => 'root'
  end
  
  def create_table
    db.create_table! :pets do
      primary_key :id
      enum :type, :elements => %w( cat dog )
      String :name
      Integer :postcode
      String :colour
      String :breed
      String :crossbreed
    end
  end
  
  def records
    filename = File.dirname(__FILE__) + '/../fixtures/appsnsw_export_with_postcode.csv'
    File.open(filename, "rb:UTF-16LE:UTF-8") {|f| f.read}.split("\r\n").map do |l|
      fields = l.split("\t").map {|f| f.strip}
      [
        fields[0],
        fields[1].downcase,
        fields[2].downcase,
        fields[3],
        fields[4],
        fields[5]
      ]
    end
  end
  
  def insert
    db[:pets].import [:name, :type, :colour, :postcode, :breed, :crossbreed], records, :slice => 500
  end
  
  def index
    db.add_index :pets, [:breed, :type]
  end
  
  def import
    create_table
    insert
    index
  end
end
