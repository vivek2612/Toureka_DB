class TouristSpot < ActiveRecord::Base
  acts_as_gmappable
  attr_accessible :category, :description, :districtName, :lattitude, :longitude, :name, :rating, :stateName

  has_many :in_proximity_ofs
  has_many :hotels, through: :in_proximity_ofs

  has_many :closer_tos
  has_many :local_transport_stands, through: :closer_tos

  has_many :reviews

  validates_presence_of :category
  validates_presence_of :districtName
  validates_presence_of :lattitude
  validates_presence_of :longitude
  validates_presence_of :name
  validates_presence_of :stateName

  validates :rating, :numericality => { :greater_than => 0, :less_than_or_equal_to => 10 }, :allow_nil => true

  def gmap4rails_address
    '#{id}'
  end
  def gmaps4rails_infowindow
    "<h1>#{name}</h1>"
  end
end 
