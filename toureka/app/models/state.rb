class State < ActiveRecord::Base
  attr_accessible :name
  has_one :state_bounded_by, dependent: :destroy
  has_one :top_left_corner,:class_name => 'MapPoint' , dependent: :destroy , :through => :state_bounded_by ,:foreign_key => 'top_left_corner_id'
  has_one :bottom_right_corner,:class_name => 'MapPoint' , dependent: :destroy , :through => :state_bounded_by , :foreign_key => 'bottom_right_corner_id'
  has_many :districts , dependent: :destroy

  validates_presence_of :name
  validates_uniqueness_of :name
end
