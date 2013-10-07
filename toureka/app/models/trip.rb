class Trip < ActiveRecord::Base
  attr_accessible :dayNumber, :startDate

  belongs_to :user
  belongs_to :tourist_spot

  validates_presence_of :dayNumber
  validates_presence_of :startDate
  validates :dayNumber, :numericality => { :greater_than => 0 , :allow_nil => true}
  validates :dayNumber, :uniqueness => {:scope => :user_id}

end
