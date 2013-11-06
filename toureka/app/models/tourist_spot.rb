class TouristSpot < ActiveRecord::Base
  acts_as_gmappable
  attr_accessible :category, :description, :districtName, :latitude, :longitude, :name, :rating, :stateName, :gmaps

  has_many :in_proximity_ofs
  has_many :hotels, through: :in_proximity_ofs

  has_many :closer_tos
  has_many :local_transport_stands, through: :closer_tos

  has_many :reviews

  has_many :buddies
  has_many :friends, :through => :buddies
  has_many :inverse_buddies , :class_name => "Buddy" , :foreign_key => "friend_id"
  has_many :inverse_friends , :through => :inverse_buddies, :source => :tourist_spot 
  validates_presence_of :category
  validates_presence_of :districtName
  validates_presence_of :latitude
  validates_presence_of :longitude
  validates_presence_of :name
  validates_presence_of :stateName

  validates :rating, :numericality => { :greater_than => 0, :less_than_or_equal_to => 10 }, :allow_nil => true

  def gmaps4rails_address
    '#{id}'
  end
  def gmaps4rails_infowindow
    "#{name}"
  end
  def gmaps4rails_sidebar
    "<span class='foo'>#{name}</span>"
  end
end 
