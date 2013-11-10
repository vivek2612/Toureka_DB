class LocalTransportStand < ActiveRecord::Base
  acts_as_gmappable
  attr_accessible :districtName, :latitude, :longitude, :name, :stateName, :localTransport, :gmaps

  has_many :near_bies
  has_many :hotels, through: :near_bies

  has_many :closer_tos
  has_many :tourist_spots, through: :closer_tos

  after_save :add_near_bies, :add_closer_tos

  validates_presence_of :districtName
  validates_presence_of :stateName
  validates_presence_of :latitude
  validates_presence_of :longitude
  validates_presence_of :name
  validates :localTransport, :inclusion => { :in => ["metro", "bus"] }

  def add_near_bies
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
      if d < 50
        nb=NearBy.new
        nb.hotel = hotel
        nb.local_transport_stand = self
        nb.save
      end
    end

    near_bies = self.near_bies.order("distance DESC")
    if(near_bies.size > 10)
      near_bies.first(near_bies.size - 10).destroy_all
    end

    hotels = self.hotels
    hotels.each do |h|
      near_bies = h.near_bies.order("distance DESC")
      if near_bies.size > 10
        near_bies.first(near_bies.size - 10).destroy_all
      end
    end

  end

  def add_closer_tos
    r = 6371
    count = 0
    TouristSpot.where(:stateName => self.stateName, :districtName =>self.districtName).each do |hotel|
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
      if d < 50
        nb=CloserTo.new
        nb.tourist_spot = hotel
        nb.local_transport_stand = self
        nb.save
      end
    end

    closer_tos = self.closer_tos.order("distance DESC")
    if(closer_tos.size > 10)
      closer_tos.first(closer_tos.size - 10).destroy_all
    end

    hotels = self.tourist_spots
    hotels.each do |h|
      closer_tos = h.closer_tos.order("distance DESC")
      if closer_tos.size > 10
        closer_tos.first(closer_tos.size - 10).destroy_all
      end
    end

  end

  def gmaps4rails_address
    '#{id}'
  end
  def gmaps4rails_infowindow
    "#{name}"
  end
  def gmaps4rails_sidebar
    "#{name}"
  end  
end
