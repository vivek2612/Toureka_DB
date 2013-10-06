class LocalTransportStand < ActiveRecord::Base
  attr_accessible :districtName, :lattitude, :longitude, :name, :stateName, :transportType

  has_many :near_bies
  has_many :hotels, through: :near_bies

  has_many :closer_tos
  has_many :tourist_spots, through: :closer_tos

  validates_presence_of :districtName
  validates_presence_of :stateName
  validates_presence_of :lattitude
  validates_presence_of :longitude
  validates_presence_of :name
  validates :transportType, :inclusion => { :in => ["metro", "bus"] }
end
