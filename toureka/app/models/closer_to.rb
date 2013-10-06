class CloserTo < ActiveRecord::Base
  attr_accessible :distance

  belongs_to :local_transport_stand
  belongs_to :tourist_spot

  validates_presence_of :distance
  validates :rating, :numericality => { :greater_than => 0 , :allow_nil => true}
end
