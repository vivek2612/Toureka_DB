class DistrictBoundedBy < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :district_id, :top_left_corner_id, :bottom_right_corner_id
  belongs_to :district
  belongs_to :top_left_corner, :class_name => 'MapPoint', dependent: :destroy , :foreign_key => 'top_left_corner_id'
  belongs_to :bottom_right_corner, :class_name => 'MapPoint', dependent: :destroy , :foreign_key => 'bottom_right_corner_id'

  validates_presence_of :district_id
end
