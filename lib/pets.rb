require File.dirname(__FILE__) + '/connectable'

class Pets
  include Connectable

  def all
    db[:pets]
  end
  
  def by_type(type)
    db[:pets].filter("type = ?", singularize(type))
  end
  
  
end