class State < ActiveRecord::Base
  attr_accessible :name
  belongs_to :state_bounded_by
  has_one :top_left_corner,:class_name => 'MapPoint' , :through => :state_bounded_by ,:foreign_key => 'top_left_corner_id'
  has_one :bottom_right_corner,:class_name => 'MapPoint' , :through => :state_bounded_by , :foreign_key => 'bottom_right_corner_id'
  has_many :districts

  validates_presence_of :name
  validates_uniqueness_of :name
end
