class AddTripConstraints < ActiveRecord::Migration
  def change
  	change_column :trips, :dayNumber, :integer, :null => false
  end
end
