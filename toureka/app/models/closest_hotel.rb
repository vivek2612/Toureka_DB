class ClosestHotel < ActiveRecord::Base
  attr_accessible :distance

  belongs_to :entry_point
  belongs_to :hotel

  validates_presence_of :distance
  validates :rating, :numericality => { :greater_than => 0 , :allow_nil => true}
end
