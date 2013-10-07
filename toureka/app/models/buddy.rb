class Buddy < ActiveRecord::Base
  attr_accessible :distance

  belongs_to :tourist_spot
  belongs_to :neighbour, :class_name => "TouristSpot"

  validates_presence_of :distance
  validates :rating, :numericality => { :greater_than => 0 , :allow_nil => true}
end
