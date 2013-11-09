class Review < ActiveRecord::Base
  attr_accessible :review, :rating, :user_id, :tourist_spot_id

  belongs_to :user
  belongs_to :tourist_spot

  after_save :modify_rating
  validates_presence_of :review

  def modify_rating
  	self.tourist_spot.update_attributes(:rating => self.tourist_spot.reviews.average(:rating).to_f)
  end
end
