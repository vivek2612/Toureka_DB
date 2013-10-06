class Hotel < ActiveRecord::Base
  attr_accessible :description, :districtName, :lattitude, :longitude, :name, :stateName

  validates_presence_of :districtName
  validates_presence_of :stateName
  validates_presence_of :lattitude
  validates_presence_of :longitude
  validates_presence_of :name
end
