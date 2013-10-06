class AddInProximityOfConstrants < ActiveRecord::Migration
  def change
  	change_column :in_proximity_ofs, :distance, :integer, :null => false
  end
end
