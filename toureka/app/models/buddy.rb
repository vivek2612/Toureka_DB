class Buddy < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :tourist_spot_id, :friend_id 

  belongs_to :tourist_spot
  belongs_to :friend, :class_name => "TouristSpot"

end
