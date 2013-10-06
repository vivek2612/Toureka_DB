class District < ActiveRecord::Base
  attr_accessible :districtName, :stateName

  validates_presence_of :stateName
  validates_presence_of :districtName
  validates_uniqueness_of :districtName, :scope => :stateName
end
