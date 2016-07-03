class DayCare < ActiveRecord::Base

  validates_presence_of :name
  validates_presence_of :zipcode
  validates_presence_of :url_name

end
