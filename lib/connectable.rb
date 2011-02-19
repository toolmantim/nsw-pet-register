module Connectable
  def db
    @db ||= Sequel.mysql "dogwars_dev", :host => '127.0.0.1', :user => 'root'
  end
end