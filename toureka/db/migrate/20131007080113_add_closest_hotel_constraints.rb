class AddClosestHotelConstraints < ActiveRecord::Migration
  	def change
	  	change_column :closest_hotels, :distance, :integer, :null => false
		add_index :closest_hotels, [:entry_point_id, :hotel_id], :name => 'closest_hotels_index'
	end
end
