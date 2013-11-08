class AddTripConstraints < ActiveRecord::Migration
  def change
  	change_column :trips, :start_date, :date, :null => false
	add_index :trips, [:user_id, :start_date]
  end
end
