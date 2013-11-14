class TouristSpot < ActiveRecord::Base
  acts_as_gmappable
  attr_accessible :category, :description, :districtName, :latitude, :longitude, :name, :rating, :stateName, :gmaps

  has_many :in_proximity_ofs, dependent: :destroy
  has_many :hotels, through: :in_proximity_ofs

  has_many :closer_tos, dependent: :destroy
  has_many :local_transport_stands, through: :closer_tos

  has_many :one_days, :dependent => :destroy

  has_many :reviews, :dependent => :destroy

  after_save :add_in_proximity_ofs, :add_closer_tos, :add_buddies

  has_many :buddies, dependent: :destroy
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


  def add_in_proximity_ofs
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
        ch=InProximityOf.new
        ch.hotel = hotel
        ch.tourist_spot = self
        ch.distance =  d
        ch.save
      end
    end

    closest_hotels = self.in_proximity_ofs.order("distance DESC")
    if(closest_hotels.size > 10)
      closest_hotels.first(closest_hotels.size - 10).destroy_all
    end

    hotels = self.hotels
    hotels.each do |h|
      closest_hotels = h.closest_hotels.order("distance DESC")
      if closest_hotels.size > 10
        closest_hotels.first(closest_hotels.size - 10).destroy_all
      end
    end

  end

  def add_closer_tos
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
        nb=CloserTo.new
        nb.tourist_spot = self
        nb.local_transport_stand = hotel
        nb.distance =  d
        nb.save
      end
    end

    closer_tos = self.closer_tos.order("distance DESC")
    if(closer_tos.size > 10)
      closer_tos.first(closer_tos.size - 10).destroy_all
    end

    hotels = self.local_transport_stands
    hotels.each do |h|
      closer_tos = h.closer_tos.order("distance DESC")
      if closer_tos.size > 10
        closer_tos.first(closer_tos.size - 10).destroy_all
      end
    end

  end

  def add_buddies
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
        nb=Buddy.new
        nb.tourist_spot = self
        nb.friend = hotel
        nb.distance = d
        nb.save
      end
    end

    buddies = self.buddies.order("distance DESC")
    if(buddies.size > 10)
      buddies.first(buddies.size - 10).each do |x|
        x.destroy
      end
    end

    hotels = self.friends
    hotels.each do |h|
      buddies = h.buddies.order("distance DESC")
      if buddies.size > 10
        buddies.first(buddies.size - 10).destroy_all
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
    "<span class='foo'>#{name}</span>"
  end
end 
