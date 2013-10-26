class StateBoundedBy < ActiveRecord::Base
  attr_accessible :state_id, :top_left_corner_id, :bottom_right_corner_id
  belongs_to :state
  belongs_to :top_left_corner, :class_name => 'MapPoint' , :foreign_key => 'top_left_corner_id'
  belongs_to :bottom_right_corner, :class_name => 'MapPoint' , :foreign_key => 'bottom_right_corner_id'

  validates_uniqueness_of :state_id
  validates_presence_of :state_id

end
