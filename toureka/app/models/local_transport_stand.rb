class LocalTransportStand < ActiveRecord::Base
  attr_accessible :districtName, :lattitude, :longitude, :name, :stateName, :transportType

  validates_presence_of :districtName
  validates_presence_of :stateName
  validates_presence_of :lattitude
  validates_presence_of :longitude
  validates_presence_of :name
  validates :transportType, :inclusion => { :in => ["metro", "bus"] }
end
