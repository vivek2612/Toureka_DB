class InProximityOf < ActiveRecord::Base
  attr_accessible :distance
  belongs_to :hotel
  belongs_to :tourist_spot


  validates_presence_of :distance
  validates :distance, :numericality => { :greater_than => 0 , :allow_nil => true}
  validates :hotel_id, :uniqueness => {:scope => :tourist_spot_id}
end
