class OneDay < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :user_id, :tourist_spot_id, :start_date, :day_number

  belongs_to :tourist_spot
  belongs_to :user

  validates_presence_of :day_number, :start_date
  validates :day_number, :numericality => { :greater_than => 0 , :allow_nil => true}
  

end