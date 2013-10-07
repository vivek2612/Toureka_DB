class CloserTo < ActiveRecord::Base
  attr_accessible :distance

  belongs_to :local_transport_stand
  belongs_to :tourist_spot

  validates_presence_of :distance
  validates :distance, :numericality => { :greater_than => 0 , :allow_nil => true}
  validates :local_transport_stand_id, :uniqueness => {:scope => :tourist_spot_id}

end
