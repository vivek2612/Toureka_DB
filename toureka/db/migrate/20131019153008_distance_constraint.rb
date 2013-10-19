class DistanceConstraint < ActiveRecord::Migration
  def change
  	execute "ALTER TABLE in_proximity_ofs ADD CONSTRAINT distanceCheck1 CHECK ( distance >= 0 );"
  	execute "ALTER TABLE closer_tos ADD CONSTRAINT distanceCheck2 CHECK ( distance >= 0 );"
  	execute "ALTER TABLE near_bies ADD CONSTRAINT distanceCheck3 CHECK ( distance >= 0 );"
  	execute "ALTER TABLE closest_hotels ADD CONSTRAINT distanceCheck4 CHECK ( distance >= 0 );"
  end
end
