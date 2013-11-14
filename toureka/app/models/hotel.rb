class Hotel < ActiveRecord::Base
  acts_as_gmappable

  attr_accessible :description, :districtName, :latitude, :longitude, :name, :stateName, :gmaps

  has_many :near_bies, dependent: :destroy
  has_many :local_transport_stands, through: :near_bies

  has_many :in_proximity_ofs, dependent: :destroy
  has_many :tourist_spots, through: :in_proximity_ofs

  has_many :closest_hotels, dependent: :destroy
  has_many :entry_points, through: :closest_hotels

  after_save :add_near_bies, :add_closest_hotels, :add_in_proximity_ofs

  def add_near_bies
    r = 6371
    count = 0
    LocalTransportStand.where(:stateName => self.stateName, :districtName =>self.districtName).each do |hotel|
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
        nb.hotel = self
        nb.local_transport_stand = hotel
        nb.distance =  d
        nb.save
      end
    end

    near_bies = self.near_bies.order("distance DESC")
    if(near_bies.size > 10)
      near_bies.first(near_bies.size - 10).destroy_all
    end

    hotels = self.local_transport_stands
    hotels.each do |h|
      near_bies = h.near_bies.order("distance DESC")
      if near_bies.size > 10
        near_bies.first(near_bies.size - 10).destroy_all
      end
    end

  end

  def add_closest_hotels
      r = 6371
    count = 0
    EntryPoint.where(:stateName => self.stateName, :districtName =>self.districtName).each do |hotel|
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
        ch.hotel = self
        ch.entry_point = hotel
        ch.distance =  d
        ch.save
      end
    end

    closest_hotels = self.closest_hotels.order("distance DESC")
    if(closest_hotels.size > 2)
      closest_hotels.first(closest_hotels.size - 2).destroy_all
    end

    hotels = self.entry_points
    hotels.each do |h|
      closest_hotels = h.closest_hotels.order("distance DESC")
      if closest_hotels.size > 10
        closest_hotels.first(closest_hotels.size - 10).destroy_all
      end
    end

  end

  def add_in_proximity_ofs
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
      if d < 100
        ch=InProximityOf.new
        ch.hotel = self
        ch.tourist_spot = hotel
        ch.distance =  d
        ch.save
      end
    end

    in_proximity_ofs = self.in_proximity_ofs.order("distance DESC")
    if(in_proximity_ofs.size > 10)
      in_proximity_ofs.first(in_proximity_ofs.size - 10).destroy_all
    end

    hotels = self.tourist_spots
    hotels.each do |h|
      in_proximity_ofs = h.in_proximity_ofs.order("distance DESC")
      if in_proximity_ofs.size > 10
        in_proximity_ofs.first(in_proximity_ofs.size - 10).destroy_all
      end
    end

  end

  validates_presence_of :districtName
  validates_presence_of :stateName
  validates_presence_of :latitude
  validates_presence_of :longitude
  validates_presence_of :name

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
