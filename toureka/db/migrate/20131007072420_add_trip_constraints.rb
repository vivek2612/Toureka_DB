class AddTripConstraints < ActiveRecord::Migration
  def change
  	change_column :trips, :dayNumber, :integer, :null => false
  	change_column :trips, :startDate, :date, :null => false
	add_index :trips, [:user_id, :startDate]
  end
end
