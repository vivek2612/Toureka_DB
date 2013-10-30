class DistrictBoundTrigger < ActiveRecord::Migration
  def change
  # 	execute"

  # 		CREATE FUNCTION my_trigger_function()
		# RETURNS trigger AS '
		# BEGIN
		# IF NOT EXISTS(
		# 	  	select count(*) from map_points as m1,map_points as m2,state_bounded_bies as s  					
	 #  			where  					
	 #  			(m1.id=NEW.top_left_corner_id and NEW.state_id=s.id and m2.id=s.top_left_corner_id and m1.latitude>m2.latitude and m1.longitude < m2.longitude)
	 #  			and  					
	 #  			(m1.id=NEW.right_bottom_corner_id and NEW.state_id=s.id and m2.id=s.right_bottom_corner_id and m1.latitude<m2.latitude and m1.longitude > m2.longitude)
		# 	  ) 
		# THEN RETURN NULL;
		#   END IF;

		
		#   RETURN NEW;
		# END' LANGUAGE 'plpgsql';"
		
  	
  end

end