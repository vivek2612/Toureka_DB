class Trip < ActiveRecord::Base
  attr_accessible :name, :start_date

  belongs_to :user

  validates_presence_of :start_date
  validates :start_date, :uniqueness => {:scope => :user_id}
end
