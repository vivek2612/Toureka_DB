class AddInProximityOfConstraints < ActiveRecord::Migration
	def change
	  	change_column :in_proximity_ofs, :distance, :integer, :null => false
		add_index :in_proximity_ofs, [:hotel_id, :tourist_spot_id]
	end
end
