class MapPoint < ActiveRecord::Base
  attr_accessible :districtName, :latitude, :longitude, :stateName

  validates_presence_of :latitude
  validates_presence_of :longitude

  
end
