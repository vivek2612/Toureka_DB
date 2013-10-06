class Trip < ActiveRecord::Base
  attr_accessible :dayNumber
  belongs_to :user
  belongs_to :tourist_spot

  validates_presence_of :dayNumber
  validates :rating, :numericality => { :greater_than => 0 , :allow_nil => true}
end
