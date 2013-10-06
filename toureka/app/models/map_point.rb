class MapPoint < ActiveRecord::Base
  attr_accessible :districtName, :lattitude, :longitude, :stateName

  validates_presence_of :districtName
  validates_presence_of :stateName
  validates_presence_of :lattitude
  validates_presence_of :longitude
end
