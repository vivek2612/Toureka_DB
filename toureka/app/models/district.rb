class District < ActiveRecord::Base
  attr_accessible :name
  belongs_to :state

  validates_presence_of :name
  validates :name, :uniqueness => {:scope => :state_id}
end
