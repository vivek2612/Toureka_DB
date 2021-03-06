class District < ActiveRecord::Base
  attr_accessible :name, :state_id
  belongs_to :state

  has_one :district_bounded_by, dependent: :destroy
  has_one :top_left_corner,:class_name => 'MapPoint' , dependent: :destroy, :through => :district_bounded_by ,:foreign_key => 'top_left_corner_id'
  has_one :bottom_right_corner,:class_name => 'MapPoint' , dependent: :destroy, :through => :district_bounded_by , :foreign_key => 'bottom_right_corner_id'

  validates_presence_of :name
  validates :name, :uniqueness => {:scope => :state_id}
end
