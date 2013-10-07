class Review < ActiveRecord::Base
  attr_accessible :review

  belongs_to :user
  belongs_to :tourist_spot

  validates_presence_of :review
end
