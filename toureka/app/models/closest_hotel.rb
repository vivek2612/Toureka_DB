class ClosestHotel < ActiveRecord::Base
  attr_accessible :distance

  belongs_to :entry_point
  belongs_to :hotel

  validates_presence_of :distance
  validates :distance, :numericality => { :greater_than => 0 , :allow_nil => true}
  validates :entry_point_id, :uniqueness => {:scope => :hotel_id}

end
