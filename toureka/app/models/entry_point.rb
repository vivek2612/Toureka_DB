class EntryPoint < ActiveRecord::Base
	acts_as_gmappable
  attr_accessible :districtName, :latitude, :longitude, :name, :stateName, :entryType, :gmaps

  has_many :closest_hotels
  has_many :hotels , through: :closest_hotels

  validates_presence_of :districtName
  validates_presence_of :stateName
  validates_presence_of :latitude
  validates_presence_of :longitude
  validates_presence_of :name

  # validates :entryType, :inclusion => { :in => ["airport", "railway"] }

  def gmaps4rails_address
    '#{id}'
  end
  def gmaps4rails_infowindow
    "<h1>#{name}</h1>"
  end  

end
