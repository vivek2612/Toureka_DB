class NearBy < ActiveRecord::Base
  attr_accessible :distance
  belongs_to :hotel
  belongs_to :local_transport_stand

  validates_presence_of :distance
  validates :distance, :numericality => { :greater_than => 0 , :allow_nil => true}
  validates :hotel_id, :uniqueness => {:scope => :local_transport_stand_id}
end
