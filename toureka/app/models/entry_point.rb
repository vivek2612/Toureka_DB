class EntryPoint < ActiveRecord::Base
	acts_as_gmappable
  attr_accessible :districtName, :latitude, :longitude, :name, :stateName, :entryType, :gmaps

  has_many :closest_hotels
  has_many :hotels , through: :closest_hotels

  after_save :add_closest_hotels

  validates_presence_of :entryType
  validates_presence_of :districtName
  validates_presence_of :stateName
  validates_presence_of :latitude
  validates_presence_of :longitude
  validates_presence_of :name

  validates :entryType, :inclusion => { :in => ["airport", "railway"] }

  def add_closest_hotels
    
    r = 6371
    count = 0
    Hotel.where(:stateName => self.stateName, :districtName =>self.districtName).each do |hotel|
      dLat = (hotel.latitude-self.latitude)*Math::PI / 180.0
      dLon = (hotel.longitude-self.longitude)*Math::PI / 180.0
      lat1 = self.latitude*Math::PI / 180.0
      lat2 = hotel.latitude*Math::PI / 180.0
      a = Math.sin(dLat/2) * Math.sin(dLat/2) + Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(lat1) * Math.cos(lat2); 
      c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
      d = r * c;
=begin
      puts "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
      puts d
      puts "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
=end
      if d < 100
        ch=ClosestHotel.new
        ch.hotel = hotel
        ch.entry_point = self
        ch.save
      end
    end

    closest_hotels = self.closest_hotels.order("distance DESC")
    if(closest_hotels.size > 10)
      closest_hotels.first(closest_hotels.size - 10).destroy_all
    end

    hotels = self.hotels
    hotels.each do |h|
      closest_hotels = h.closest_hotels.order("distance DESC")
      if closest_hotels.size > 2
        closest_hotels.first(closest_hotels.size - 2).destroy_all
      end
    end

  end

  def gmaps4rails_address
    '#{id}'
  end
  def gmaps4rails_sidebar
    "#{name}"
  end  
  def gmaps4rails_infowindow
    "#{name}"
  end

end
