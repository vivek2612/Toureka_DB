class AddNearByConstraints < ActiveRecord::Migration
  def change
  	change_column :near_bies, :distance, :integer, :null => false
	add_index :near_bies, [:hotel_id, :local_transport_stand_id]
  end
end
