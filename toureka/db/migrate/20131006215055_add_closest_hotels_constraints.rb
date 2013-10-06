class AddClosestHotelsConstraints < ActiveRecord::Migration
  def change
  	change_column :closest_hotels, :distance, :integer, :null => false
  end
end
