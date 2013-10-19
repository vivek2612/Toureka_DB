class District < ActiveRecord::Base
  attr_accessible :name
  belongs_to :state

  belongs_to :district_bounded_by
  has_one :top_left_corner,:class_name => 'MapPoint' , :through => :district_bounded_by ,:foreign_key => 'top_left_corner_id'
  has_one :bottom_right_corner,:class_name => 'MapPoint' , :through => :district_bounded_by , :foreign_key => 'bottom_right_corner_id'

  validates_presence_of :name
  validates :name, :uniqueness => {:scope => :state_id}
end
