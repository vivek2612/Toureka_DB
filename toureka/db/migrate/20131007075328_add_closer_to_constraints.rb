class AddCloserToConstraints < ActiveRecord::Migration
  	def change
	  	change_column :closer_tos, :distance, :integer, :null => false
		add_index :closer_tos, [:local_transport_stand_id, :tourist_spot_id], :name => 'closer_tos_index'
	end
end
